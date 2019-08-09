#!/bin/bash

IP=/usr/bin/ip
BRIDGE=vmbr0
TAP=$1

# make sure bridge exists
ip link add name $BRIDGE type bridge
ip link set $BRIDGE up
ip link set $BRIDGE promisc on

# add tap interface to bridge
$IP link set "$TAP" up
$IP link set "$TAP" promisc on
$IP link set "$TAP" master $BRIDGE
