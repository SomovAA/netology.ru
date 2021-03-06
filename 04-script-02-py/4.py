#!/usr/bin/env python3

import socket
import time

domains = {'drive.google.com': [], 'mail.google.com': [], 'google.com': []}

while True:
    for domain, ips in domains.items():
        ip = socket.gethostbyname(domain)

        if len(ips) == 0:
            print(f"{domain} - {ip}")
            ips.append(ip)
            continue

        if ips[-1] != ip:
            print(f"[ERROR] {domain} IP mismatch: {ips[-1]} {ip}")
            ips.append(ip)
            continue

        print(f"{domain} - {ip}")
    time.sleep(5)
