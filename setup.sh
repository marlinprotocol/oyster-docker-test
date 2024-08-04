#!/bin/sh

set -e

# setting an address for loopback
ifconfig lo 127.0.0.1
ip addr

# adding a default route
ip route add default dev lo src 127.0.0.1
ip route

# iptables rules to route traffic to transparent proxy
# hacky hack hack
iptables -t nat -N DOCKER
iptables -t nat -A OUTPUT -d 172.17.0.0/16 -j DOCKER
iptables -A OUTPUT -t nat -p tcp --dport 1:65535 ! -d 127.0.0.1  -j DNAT --to-destination 127.0.0.1:1200
iptables -L -t nat

# generate identity key
/app/keygen-ed25519 --secret /app/id.sec --public /app/id.pub

# your custom setup goes here

# here be dragons
cat /app/iptablesPath.txt
ls -lath `cat /app/iptablesPath.txt`
rm -rf `cat /app/iptablesPath.txt`

# starting supervisord
cat /etc/supervisord.conf
/app/supervisord
