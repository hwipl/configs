#!/bin/bash

BRIDGE=$1

# create bridge
ip link add name "$BRIDGE" type bridge

# make sure bridge is up
ip link set "$BRIDGE" up

# set promiscuous mode
ip link set "$BRIDGE" promisc on
