import socket
import threading
import time

# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server_address = ('0.0.0.0', 8080)
sock.bind(server_address)


total_sleep_time = 0
n_threads = 0
lock = threading.Lock()

def handle_client(data, address):
    global n_threads
    global total_sleep_time
    global lock
    with lock:
        n_threads += 1
    sleep_time = int.from_bytes(data, byteorder='big')
    print('Received {} from {}'.format(sleep_time, address), flush=True)
    time.sleep(sleep_time)
    with lock:
        total_sleep_time += sleep_time
    print("Finished sleeping for {}".format(sleep_time), flush=True)
    print('Total sleep time: {}'.format(total_sleep_time), flush=True)
    with lock:
        n_threads -= 1

    sock.sendto('D'.encode(), ('lb.a2-b_default', 8080))
    

sock.sendto('S'.encode(), ('lb.a2-b_default', 8080))

while True:
    data, address = sock.recvfrom(8)
    if n_threads >= 5:
        print('Server is busy, try again later', flush=True)
        continue
    if data:
        threading.Thread(target=lambda: handle_client(data, address)).start()
