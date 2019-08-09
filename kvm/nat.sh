#!/bin/bash

SYSCTL=/usr/bin/sysctl
IPTABLES=/usr/bin/iptables
IF=$1
IP=$2

# enable ip forwarding
$SYSCTL net.ipv4.ip_forward=1

# enable nat on specified interface for specified ip range
$IPTABLES -t nat -A POSTROUTING -s "$IP" -j MASQUERADE
$IPTABLES -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -o "$IF" -j ACCEPT
$IPTABLES -A FORWARD -i "$IF" -j ACCEPT
