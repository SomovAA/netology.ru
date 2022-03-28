#!/usr/bin/env python3

import socket
import time
import json
import yaml


def log(obj):
    with open("log.json", "w") as log:
        log.write(json.dumps(obj))

    with open("log.yaml", "w") as log:
        log.write(yaml.dump(obj, explicit_start=True, explicit_end=True))

    return None


domains = {'drive.google.com': [], 'mail.google.com': [], 'google.com': []}

while True:
    obj = dict()
    for domain, ips in domains.items():
        ip = socket.gethostbyname(domain)
        obj[domain] = ip

        if len(ips) == 0:
            print(f"{domain} - {ip}")
            ips.append(ip)
            continue

        if ips[-1] != ip:
            print(f"[ERROR] {domain} IP mismatch: {ips[-1]} {ip}")
            ips.append(ip)
            continue

        print(f"{domain} - {ip}")
    log(obj)
    time.sleep(5)
