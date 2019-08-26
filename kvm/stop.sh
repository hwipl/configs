#!/bin/bash

SOCK_DIR=/tmp/qemu-VMs

# stop all VMs that have a monitor socket file in SOCK_DIR
for i in "$SOCK_DIR"/*.sock
do
	[[ -e "$i" ]] || break	# handle case of no files
	echo "system_powerdown" | nc -U "$i"
done

