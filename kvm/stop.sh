#!/bin/bash

SOCK_DIR=/tmp/qemu-VMs/vmbr0
PID_DIR=$SOCK_DIR

# scripts
NAT_SCRIPT=./nat.sh
BR_SCRIPT=./bridge.sh
ADD_ROUTE=../net/add_route.sh
FORWARD_PORT=../net/forward_port.sh

# bridge config
BRIDGE_PREFIX=10.10.10.0/24
BRIDGE_IP=10.10.10.1/24

# other programs
CAT=/usr/bin/cat

# stop all VMs that have a monitor socket file in SOCK_DIR
for i in "$SOCK_DIR"/*.sock
do
	[[ -e "$i" ]] || break	# handle case of no files
	echo "system_powerdown" | nc -U "$i" &
done

# wait for powerdown commands
wait

# stop dnsmasq processes that have a pid file in PID_DIR
for i in "$PID_DIR"/dnsmasq-*.pid
do
	[[ -e "$i" ]] || break	# handle case of no files
	PID=$($CAT "$i")
	kill "$PID"
done

# delete additional routes to bridge interface itself
$ADD_ROUTE 10.10.11.0/24 10.10.10.2 vmbr0 stop

# disable forwarding additional ports to vms on the bridge
$FORWARD_PORT 1194 10.10.10.2 1194 stop

# disable nat and ip forwarding on bridge interface
$NAT_SCRIPT vmbr0 $BRIDGE_PREFIX stop

# stop vm bridge
$BR_SCRIPT vmbr0 $BRIDGE_IP stop
