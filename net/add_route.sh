#!/bin/bash

# network prefix, gateway, device
PREFIX=$1
GW=$2
DEV=$3
CMD=$4

IP=/usr/bin/ip

if [ "$#" -lt 3 ]; then
	echo "Usage:"
	echo "    $0 <prefix> <gateway> <dev> [stop]"
	echo "Arguments:"
	echo "    prefix:  route this network prefix"
	echo "    gateway: route via this gateway"
	echo "    dev:     use this net device for route"
	echo "    stop:    stop this routing rule"
	exit
fi

if [ "$CMD" == "stop" ]; then
	echo "Stopping to route $PREFIX via $GW on dev $DEV"
	$IP route del "$PREFIX" via "$GW" dev "$DEV"
	exit
fi

echo "Starting to route $PREFIX via $GW on dev $DEV"
$IP route add "$PREFIX" via "$GW" dev "$DEV"
