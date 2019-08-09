#!/bin/bash

IP=/usr/bin/ip
TAP=$1

# remove tap interface from bridge
$IP link set "$TAP" nomaster
$IP link set "$TAP" promisc off
$IP link set "$TAP" down
