import socket
import sys
import time
import os
import random

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server_address = ('lb.a2-b_default', 8080)
# server_address = ('172.20.0.1', 8080)

total_sleep_time = 0
for _ in range(40):
    sleep_time = random.randint(1, 5) * 4
    total_sleep_time += sleep_time
    sent = sock.sendto(sleep_time.to_bytes(8, byteorder='big'), server_address)
    print('[SENT] {}'.format(sleep_time), flush=True)
    
    time.sleep(1.5)

print("Total sleep time: {}".format(total_sleep_time), flush=True)

print('Closing socket', flush=True)
sock.close()

