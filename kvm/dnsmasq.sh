#!/bin/bash

DNSMASQ=/usr/bin/dnsmasq
IF=$1
IP_RANGE=$2
ROUTES=$3

# pid file
PID_DIR=/tmp/qemu-VMs
PID_FILE=$PID_DIR/dnsmasq-$IF.pid

# set command line
CMD_LINE="$DNSMASQ"
CMD_LINE="$CMD_LINE --interface=$IF"
CMD_LINE="$CMD_LINE --bind-interfaces"
CMD_LINE="$CMD_LINE --except-interface=lo"
CMD_LINE="$CMD_LINE --pid-file=$PID_FILE"
CMD_LINE="$CMD_LINE --dhcp-range=$IP_RANGE"

# configure static routes on dhcp clients
CMD_LINE="$CMD_LINE --dhcp-option=option:classless-static-route,$ROUTES"

# treat remaining arguments as dhcp-host definitions
shift 3
for i in "${@}"
do
	CMD_LINE="$CMD_LINE --dhcp-host=$i"
done

# make sure pid_dir and pid_file exist
if [ ! -e "$PID_DIR" ]; then
	mkdir "$PID_DIR"
fi
if [ ! -e "$PID_FILE" ]; then
	touch "$PID_FILE"
fi

# run the command
$CMD_LINE
