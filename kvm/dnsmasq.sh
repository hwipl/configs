#!/bin/bash

DNSMASQ=/usr/bin/dnsmasq
IF=$1
IP_START=$2
IP_END=$3

$DNSMASQ \
	--interface "$IF" \
	--bind-interfaces \
	--except-interface lo \
	--dhcp-range="$IP_START","$IP_END"
