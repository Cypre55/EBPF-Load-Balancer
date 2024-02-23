#include <stdbool.h>
#include <stddef.h>
#include <string.h>
#include <linux/bpf.h>
#include <linux/icmp.h>
#include <linux/if_ether.h>
#include <linux/if_vlan.h>
#include <linux/in.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <sys/cdefs.h>

#include <bpf_helpers.h>
#include <bpf_endian.h>

#define MAX_SERVERS 3
#define MAX_THREADS 5
#define MAX_UDP_LENGTH 1480


struct dest_info {
    __u32 saddr;
    __u32 daddr;
    __u8 dmac[6];
    __u16 free_threads;
};

struct bpf_map_def SEC("maps") ip_to_key = {
    .type        = BPF_MAP_TYPE_HASH,
    .key_size    = sizeof(__u32),
    .value_size  = sizeof(__u32),
    .max_entries = MAX_SERVERS,
};

struct bpf_map_def SEC("maps") servers = {
	.type        = BPF_MAP_TYPE_ARRAY,
	.key_size    = sizeof(__u32),
	.value_size  = sizeof(struct dest_info),
	.max_entries = MAX_SERVERS,
};

struct bpf_map_def SEC("maps") server_cnt = {
    .type        = BPF_MAP_TYPE_ARRAY,
    .key_size    = sizeof(__u32),
    .value_size  = sizeof(__u16),
    .max_entries = 1,
};

struct bpf_map_def SEC("maps") queue = {
    .type        = BPF_MAP_TYPE_QUEUE,
    .key_size    = 0,
    .value_size  = sizeof(__u64),
    .max_entries = 100,
};

static __always_inline __u16 ip_checksum(unsigned short *buf, int bufsz) {
    unsigned long sum = 0;

    while (bufsz > 1) {
        sum += *buf;
        buf++;
        bufsz -= 2;
    }

    if (bufsz == 1) {
        sum += *(unsigned char *)buf;
    }

    sum = (sum & 0xffff) + (sum >> 16);
    sum = (sum & 0xffff) + (sum >> 16);

    return ~sum;
}

static __always_inline __u16 udp_checksum(struct iphdr *ip, struct udphdr * udp, void * data_end)
{
    __u16 csum = 0;
    __u16 *buf = (__u16*)udp;

    csum += ip->saddr;
    csum += ip->saddr >> 16;
    csum += ip->daddr;
    csum += ip->daddr >> 16;
    csum += (__u16)ip->protocol << 8;
    csum += udp->len;

    for (int i = 0; i < MAX_UDP_LENGTH; i += 2) {
        if ((void *)(buf + 1) > data_end) {
            break;
        }
        csum += *buf;
        buf++;
    }

    if ((void *)buf + 1 <= data_end) {
        csum += *(__u8 *)buf;
    }

   csum = ~csum;
   return csum;
}

static __always_inline __u32 get_available_backend()
{
    __u32 selected_key = -1;
    __u16 max_free_threads = 0;

    bpf_printk("[SELECT]");

    {
        __u32 i = 0;
        struct dest_info *info = bpf_map_lookup_elem(&servers, &i);
        if (info && info->saddr != 0)
        {
            bpf_printk("Backend %pI4: %d", &info->saddr, info->free_threads);
            if (info->free_threads > max_free_threads)
            {
                max_free_threads = info->free_threads;
                selected_key = i;
            }
        }

        i = 1;
        info = bpf_map_lookup_elem(&servers, &i);
        if (info && info->saddr != 0)
        {
            bpf_printk("Backend %pI4: %d", &info->saddr, info->free_threads);
            if (info->free_threads > max_free_threads)
            {
                max_free_threads = info->free_threads;
                selected_key = i;
            }
        }
            
        i = 2;
        info = bpf_map_lookup_elem(&servers, &i);
        if (info && info->saddr != 0)
        {
            bpf_printk("Backend %pI4: %d", &info->saddr, info->free_threads);
            if (info->free_threads > max_free_threads)
            {
                max_free_threads = info->free_threads;
                selected_key = i;
            }
        }
    }

    if (selected_key == -1)
    {
        bpf_printk("Selected backend: None");
    }
    else
    {
        struct dest_info *info = bpf_map_lookup_elem(&servers, &selected_key);
        if (!info)
            return XDP_ABORTED;
            

        bpf_printk("Selected backend: %pI4", &info->saddr);
    }

    bpf_printk("------------------------------------");

    return selected_key;
}

static __always_inline bool is_queue_empty()
{
    __u64 value;
    long status = bpf_map_peek_elem(&queue, &value);
    if (status != 0)
        return true;
    return false;
}

static __always_inline void enqueue(__u64 value)
{
    bpf_map_push_elem(&queue, &value, BPF_ANY);
}

static __always_inline __u64 dequeue()
{
    __u64 value;
    bpf_map_pop_elem(&queue, &value);
    return value;
}

static __always_inline int send_to_backend(__u32 selected_key, struct ethhdr* eth, struct iphdr *iph, struct udphdr * udph, void * data_end)
{
    struct dest_info *info = bpf_map_lookup_elem(&servers, &selected_key);
    if (!info)
    {
        bpf_printk("Backend not found");
        bpf_printk("");
        return XDP_ABORTED;
    }

    info->free_threads--;
    bpf_map_update_elem(&servers, &selected_key, info, BPF_ANY);
    
    iph->saddr = info->daddr;
    iph->daddr = info->saddr;
    __builtin_memcpy(eth->h_source, eth->h_dest, sizeof(__u8) * 6);
    __builtin_memcpy(eth->h_dest, info->dmac, sizeof(__u8) * 6);

    iph->tot_len = bpf_htons(data_end - (void *)iph);
    udph->len = bpf_htons(data_end - (void *)udph);

    iph->check = 0;
    iph->check = ip_checksum((__u16 *)iph, sizeof(struct iphdr));
    udph->check = 0;
    udph->check = udp_checksum(iph, udph, data_end);

    bpf_printk("[SENT] %pI4", &iph->daddr);
    bpf_printk("------------------------------------");

    bpf_printk("");
    return XDP_TX;
}

SEC("xdp")
int load_balancer(struct xdp_md *ctx)
{
    void *data = (void *)(long)ctx->data;
    void *data_end = (void *)(long)ctx->data_end;

    struct ethhdr *eth = data;
    if (data + sizeof(struct ethhdr) > data_end)
        return XDP_ABORTED;

    if (bpf_ntohs(eth->h_proto) != ETH_P_IP)
        return XDP_PASS;

    struct iphdr *iph = data + sizeof(struct ethhdr);
    if (data + sizeof(struct ethhdr) + sizeof(struct iphdr) > data_end)
        return XDP_ABORTED;

    if (iph->protocol != IPPROTO_UDP)
        return XDP_PASS;

    struct udphdr *udph = data + sizeof(struct ethhdr) + sizeof(struct iphdr);
    if (data + sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct udphdr) > data_end)
        return XDP_ABORTED;

    if (bpf_ntohs(udph->dest) != 8080)
        return XDP_PASS;

    void *payload = data + sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct udphdr);
    __u32 payload_size = data_end - payload;

    if (payload_size == 1)
    {
        bpf_printk("------------------------------------");
        bpf_printk("[BACKEND] %pI4", &iph->saddr);
        bpf_printk("------------------------------------");

        __u32 ip_key = iph->saddr;
        __u32 *server_key_info = bpf_map_lookup_elem(&ip_to_key, &ip_key);
        __u32 server_key;
        if (!server_key_info)
        {
            __u32 cnt_key = 0;
            __u16 *cnt = bpf_map_lookup_elem(&server_cnt, &cnt_key);
            if (!cnt)
            {
                __u16 new_cnt = 0;
                bpf_map_update_elem(&server_cnt, &cnt_key, &new_cnt, BPF_ANY);
                cnt = bpf_map_lookup_elem(&server_cnt, &cnt_key);
                if (!cnt)
                    return XDP_ABORTED;
            }
            server_key = *cnt;
            bpf_map_update_elem(&ip_to_key, &ip_key, &server_key, BPF_ANY);
        }
        else
        {
            server_key = *server_key_info;
        }

        struct dest_info *info = bpf_map_lookup_elem(&servers, &server_key);
        if (!info || info->saddr == 0)
        {
            bpf_printk("[REGISTERED]");
            bpf_printk("------------------------------------");
            bpf_printk("");

            struct dest_info new_info;
            __builtin_memcpy(&new_info.saddr, &(iph->saddr), sizeof(new_info.saddr));
            __builtin_memcpy(&new_info.daddr, &(iph->daddr), sizeof(new_info.daddr));
            __builtin_memcpy(new_info.dmac, eth->h_source, sizeof(__u8) * 6);
            new_info.free_threads = MAX_THREADS;
            bpf_map_update_elem(&servers, &server_key, &new_info, BPF_ANY);

            __u32 cnt_key_1 = 0;
            __u16 *cnt_val = bpf_map_lookup_elem(&server_cnt, &cnt_key_1);
            if (!cnt_val)
            {
                return XDP_ABORTED;
            }
            *cnt_val = *cnt_val + 1;
            bpf_map_update_elem(&server_cnt, &cnt_key_1, cnt_val, BPF_ANY);

            bpf_printk("");
            return XDP_DROP;
        }
        else
        {
            bpf_printk("[COMPLETE]");
            bpf_printk("------------------------------------");

            info->free_threads++;
            if (info->free_threads > MAX_THREADS)
                info->free_threads = MAX_THREADS;

            bpf_map_update_elem(&servers, &server_key, info, BPF_ANY);

            if (!is_queue_empty())
            {
                __u32 selected_key = get_available_backend();
                if (selected_key == -1)
                {
                    bpf_printk("[UNAVAILABLE]");
                    bpf_printk("------------------------------------");
                    bpf_printk("");
                    return XDP_ABORTED;
                }

                bpf_xdp_adjust_tail(ctx, 7);
                data = (void *)(long)ctx->data;
                data_end = (void *)(long)ctx->data_end;

                eth = data;
                if (data + sizeof(struct ethhdr) > data_end)
                    return XDP_ABORTED;

                iph = data + sizeof(struct ethhdr);
                if (data + sizeof(struct ethhdr) + sizeof(struct iphdr) > data_end)
                    return XDP_ABORTED;

                udph = data + sizeof(struct ethhdr) + sizeof(struct iphdr);
                if (data + sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct udphdr) > data_end)
                    return XDP_ABORTED;


                void *payload = data + sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct udphdr);

                __u64 value = dequeue();
                if (payload + sizeof(__u64) > data_end)
                    return XDP_ABORTED;
                __builtin_memcpy(payload, &value, sizeof(__u64));

                bpf_printk("[QUEUE] Dequeued: %llu", __builtin_bswap64(value));
                bpf_printk("------------------------------------");


                return send_to_backend(selected_key, eth, iph, udph, data_end);
            }
            else
            {
                bpf_printk("[QUEUE] Empty");
                bpf_printk("------------------------------------");
                bpf_printk("");

                return XDP_DROP;
            }

        }
        
        
    }
    else if (payload_size == 8)
    {
        bpf_printk("------------------------------------");
        bpf_printk("[CLIENT] %pI4", &iph->saddr);
        bpf_printk("------------------------------------");

        __u32 selected_key = get_available_backend();

        if (selected_key == -1)
        {
            bpf_printk("[UNAVAILABLE]");

            __u64 value;
            if (payload + sizeof(__u64) > data_end)
                return XDP_ABORTED;
            __builtin_memcpy(&value, payload, sizeof(__u64));

            enqueue(value);
            bpf_printk("[QUEUE] Enqueued: %llu", __builtin_bswap64(value));
            bpf_printk("------------------------------------");

            bpf_printk("");

            return XDP_ABORTED;
        }


        return send_to_backend(selected_key, eth, iph, udph, data_end);
    }

    return XDP_PASS;

}

char _license[] SEC("license") = "GPL";
