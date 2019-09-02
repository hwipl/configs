#!/bin/bash

SOCK_DIR=/tmp/qemu-VMs

# scripts
NAT_SCRIPT=./nat.sh
BR_SCRIPT=./bridge.sh

# bridge config
BRIDGE_PREFIX=10.10.10.0/24
BRIDGE_IP=10.10.10.1/24

# stop all VMs that have a monitor socket file in SOCK_DIR
for i in "$SOCK_DIR"/*.sock
do
	[[ -e "$i" ]] || break	# handle case of no files
	echo "system_powerdown" | nc -U "$i"
done

# disable nat and ip forwarding on bridge interface
$NAT_SCRIPT vmbr0 $BRIDGE_PREFIX stop

# stop vm bridge
$BR_SCRIPT vmbr0 $BRIDGE_IP stop
