#!/bin/bash

SOCK_DIR=/tmp/qemu-VMs

# scripts
NAT_SCRIPT=./nat.sh

# bridge config
BRIDGE_PREFIX=10.10.10.0/24

# stop all VMs that have a monitor socket file in SOCK_DIR
for i in "$SOCK_DIR"/*.sock
do
	[[ -e "$i" ]] || break	# handle case of no files
	echo "system_powerdown" | nc -U "$i"
done

# disable nat and ip forwarding on bridge interface
$NAT_SCRIPT vmbr0 $BRIDGE_PREFIX stop
