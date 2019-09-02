#!/bin/bash

# external port to be forwarded
PORT=$1

# forwarding destination IP and port
DEST_IP=$2
DEST_PORT=$3

# command, e.g., stop/delete this rule
CMD=$4

IPTABLES=/usr/bin/iptables

if [ $# -lt 3 ]; then
	echo "Usage:"
	echo "    $0 <port> <dest_ip> <dest_port> [stop]"
	echo "Arguments:"
	echo "    port:      external port"
	echo "    dest_ip:   internal forwarding IP"
	echo "    dest_port: internal forwarding port"
	echo "    stop:      stop this forwarding rule"
	exit
fi

if [ "$CMD" == "stop" ]; then
	echo "Stopping to forward port $PORT to $DEST_IP:$DEST_PORT."
	$IPTABLES \
		-t nat \
		-D PREROUTING \
		-p udp \
		--dport "$PORT" \
		-j DNAT \
		--to "$DEST_IP:$DEST_PORT"

	exit
fi

echo "Starting to forward port $PORT to $DEST_IP:$DEST_PORT."
$IPTABLES \
	-t nat \
	-A PREROUTING \
	-p udp \
	--dport "$PORT" \
	-j DNAT \
	--to "$DEST_IP:$DEST_PORT"
