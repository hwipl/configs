#!/bin/bash

SYSCTL=/usr/bin/sysctl
IPTABLES=/usr/bin/iptables
IF=$1
IP=$2
CMD=$3

if [ "$CMD" == "stop" ]; then
	# disable all NAT/routing settings
	echo "Disabling NAT/routing settings."

	# disable ip forwarding
	$SYSCTL net.ipv4.ip_forward=0

	# disable nat on specified interface for specified ip range
	$IPTABLES -t nat -D POSTROUTING -s "$IP" -j MASQUERADE
	$IPTABLES -D FORWARD -m conntrack --ctstate RELATED,ESTABLISHED \
		-o "$IF" -d "$IP" -j ACCEPT
	$IPTABLES -D FORWARD -i "$IF" -s "$IP" -j ACCEPT
	exit
fi

# enable all NAT/routing settings
echo "Enabling NAT/routing settings."

# enable ip forwarding
$SYSCTL net.ipv4.ip_forward=1

# enable nat on specified interface for specified ip range
$IPTABLES -t nat -A POSTROUTING -s "$IP" -j MASQUERADE
$IPTABLES -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED \
	-o "$IF" -d "$IP" -j ACCEPT
$IPTABLES -A FORWARD -i "$IF" -s "$IP" -j ACCEPT
