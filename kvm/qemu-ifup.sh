#!/bin/bash

IP=/usr/bin/ip
BRIDGE=vmbr0
TAP=$1

# add tap interface to bridge
$IP link set "$TAP" up
$IP link set "$TAP" promisc on
$IP link set "$TAP" master $BRIDGE
