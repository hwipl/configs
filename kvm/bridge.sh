#!/bin/bash

IP_TOOL=/usr/bin/ip
BRIDGE=$1
IP=$2

# create bridge
$IP_TOOL link add name "$BRIDGE" type bridge

# make sure bridge is up
$IP_TOOL link set "$BRIDGE" up

# set promiscuous mode
$IP_TOOL link set "$BRIDGE" promisc on

# add IP address to bridge
$IP_TOOL address add "$IP" dev "$BRIDGE"
