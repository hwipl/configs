#!/bin/bash

DNSMASQ=/usr/bin/dnsmasq
IF=$1
IP_RANGE=$2
ROUTES=$3

# set command line
CMD_LINE="$DNSMASQ"
CMD_LINE="$CMD_LINE --interface=$IF"
CMD_LINE="$CMD_LINE --bind-interfaces"
CMD_LINE="$CMD_LINE --except-interface=lo"
CMD_LINE="$CMD_LINE --dhcp-range=$IP_RANGE"

# configure static routes on dhcp clients
CMD_LINE="$CMD_LINE --dhcp-option=option:classless-static-route,$ROUTES"

# treat remaining arguments as dhcp-host definitions
shift 3
for i in "${@}"
do
	CMD_LINE="$CMD_LINE --dhcp-host=$i"
done

$CMD_LINE
