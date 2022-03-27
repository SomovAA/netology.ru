#!/usr/bin/env bash

# В будущем легко вынести через передачу параметров
ips=("192.168.0.1" "173.194.222.113" "87.250.250.242")
port=80
attempts=5

for ip in ${ips[@]}
do
  echo $ip
  attempt=0
  while ((attempt < attempts))
  do
    curl -s $ip:$port >> log
    attempt=$[$attempt+1]
    echo $attempt
  done
done