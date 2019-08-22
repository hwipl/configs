#!/bin/bash

SYSCTLCONF=/etc/sysctl.d/90-ip-forward.conf

SYSCTL=/usr/bin/sysctl

# if file sysctl config file already exists, stop here
if [ -f "$SYSCTLCONF" ]; then
	echo "$SYSCTLCONF already exists."
	exit
fi

# create config file
echo "net.ipv4.ip_forward=1" > $SYSCTLCONF

# load config file
$SYSCTL --load $SYSCTLCONF
