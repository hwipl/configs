#!/bin/bash

IP_TOOL=/usr/bin/ip
BRIDGE=$1
IP=$2
CMD=$3

if [ "$CMD" == "stop" ]; then
	# disable the bridge
	echo "Disabling bridge $BRIDGE."

	# delete IP address from bridge
	$IP_TOOL address del "$IP" dev "$BRIDGE"

	# set promiscuous mode off
	$IP_TOOL link set "$BRIDGE" promisc off

	# make sure bridge is down
	$IP_TOOL link set "$BRIDGE" down

	# delete bridge
	$IP_TOOL link del name "$BRIDGE" type bridge

	exit
fi

# enable the bridge
echo "Enabling bridge $BRIDGE."

# create bridge
$IP_TOOL link add name "$BRIDGE" type bridge

# make sure bridge is up
$IP_TOOL link set "$BRIDGE" up

# set promiscuous mode
$IP_TOOL link set "$BRIDGE" promisc on

# add IP address to bridge
$IP_TOOL address add "$IP" dev "$BRIDGE"
