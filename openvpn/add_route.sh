#!/bin/bash

# network prefix, gateway, device
PREFIX=$1
GW=$2
DEV=$3

IP=/usr/bin/ip

if [ "$#" -lt 3 ]; then
	echo "Usage:"
	echo "    $0 <prefix> <gateway> <dev>"
	echo "Arguments:"
	echo "    prefix:  route this network prefix"
	echo "    gateway: route via this gateway"
	echo "    dev:     use this net device for route"
	exit
fi

$IP route add "$PREFIX" via "$GW" dev "$DEV"
