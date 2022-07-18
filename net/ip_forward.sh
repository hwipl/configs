#!/bin/bash

# sysctl
SYSCTL=/usr/bin/sysctl

# usage
USAGE="Usage:
  $0 start
  $0 stop
"

# start ip forwarding
function start_ip_forward {
	$SYSCTL -w net.ipv4.ip_forward=1
}

# stop ip forwarding
function stop_ip_forward {
	$SYSCTL -w net.ipv4.ip_forward=0
}

CMD=$1
case $CMD in
"start")
	start_ip_forward
	;;
"stop")
	stop_ip_forward
	;;
*)
	echo "$USAGE"
	;;
esac
