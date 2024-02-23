import socket
import sys


if __name__ == '__main__':

    # Create a UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_address = ('0.0.0.0', 8080)
    sock.bind(server_address)

    while True:
        data, address = sock.recvfrom(8)
        print("[RECV] Data " + str(int.from_bytes(data, byteorder='big')) \
              + " from " + str(address), flush=True)
    




