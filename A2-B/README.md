# AOS Assignment 2

## Part B

#### Usage

```
docker compose build
```

Start 6 Terminal Windows (in the following order)

```
docker compose up lb

sudo cat /sys/kernel/debug/tracing/trace_pipe

docker compose up server1

docker compose up server2

docker compose up server3

docker compose up client
```

#### Modes

Fast Client: Please modify the `time.sleep(1.5)` in ./client/client.py to `time.sleep(0.5)`. In this mode, we can observe the queue start to fill up.



Slow Client: `time.sleep(1.5)` Queue might not fill up, but gives enough time to observer the logs

#### Info

Each server sends a 1 byte ping to the Load Balancer to register itself at the start

Server sends  a 1 byte ping on completion of job and prints total time slept.

The load balancers selects a backend with the most number of free threads.
