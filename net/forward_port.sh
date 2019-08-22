#!/bin/bash

# external port to be forwarded
PORT=$1

# forwarding destination IP and port
DEST_IP=$2
DEST_PORT=$3

IPTABLES=/usr/bin/iptables

if [ $# -lt 3 ]; then
	echo "Usage:"
	echo "    $0 <port> <dest_ip> <dest_port>"
	echo "Arguments:"
	echo "    port:      external port"
	echo "    dest_ip:   internal forwarding IP"
	echo "    dest_port: internal forwarding port"
	exit
fi

$IPTABLES \
	-t nat \
	-A PREROUTING \
	-p udp \
	--dport "$PORT" \
	-j DNAT \
	--to "$DEST_IP:$DEST_PORT"
