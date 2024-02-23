import socket
import sys
import random
import time

if __name__ == '__main__':
    saddr = "server.a2-a_default"
    sport = 8080

    # Create a UDP socket
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    server_address = ('0.0.0.0', 8080)
    sock.bind(server_address)

    # Send data
    for i in range(1, 500):
        sent = sock.sendto(i.to_bytes(8, byteorder='big'), (saddr, sport))
        print("[SENT] Data " + str(i), flush=True)
        time.sleep(1)

    




