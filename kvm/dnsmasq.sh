#!/bin/bash

DNSMASQ=/usr/bin/dnsmasq
IF=$1
IP_RANGE=$2

# set command line
CMD_LINE="$DNSMASQ"
CMD_LINE="$CMD_LINE --interface=$IF"
CMD_LINE="$CMD_LINE --bind-interfaces"
CMD_LINE="$CMD_LINE --except-interface=lo"
CMD_LINE="$CMD_LINE --dhcp-range=$IP_RANGE"

$CMD_LINE
