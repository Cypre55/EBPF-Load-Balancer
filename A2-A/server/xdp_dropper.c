#include <stddef.h>
#include <linux/bpf.h>
#include <linux/in.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/tcp.h>
#include <linux/udp.h>
#include <bpf_helpers.h>
#include <bpf_endian.h>

SEC("xdp")
int udp_dropper(struct xdp_md *ctx)
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
    __u64 value;
    if (payload + sizeof(__u64) > data_end)
        return XDP_ABORTED;
    __builtin_memcpy(&value, payload, sizeof(__u64));
    value = __builtin_bswap64(value);

    bpf_printk("------------------------------------");
    bpf_printk("[CLIENT] Packet Received");
    bpf_printk("------------------------------------");
    bpf_printk("[DATA] %llu", value);
    bpf_printk("------------------------------------");
    
    if (value % 2 == 1) {
        bpf_printk("[ODD] Passing");
        bpf_printk("------------------------------------");
        bpf_printk("");
        return XDP_PASS;
    }

    bpf_printk("[EVEN] Dropping");
    bpf_printk("------------------------------------");
    bpf_printk("");
    return XDP_DROP;
}
char _license[] SEC("license") = "GPL";
