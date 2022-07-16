#!/bin/bash

# configuration
IF=$2
IP_RANGE=$3
ROUTES=$4

# dnsmasq
DNSMASQ=/usr/bin/dnsmasq

# pid file
PID_DIR=/tmp/dnsmasq-$IF
PID_FILE=$PID_DIR/dnsmasq-$IF.pid

# usage
USAGE="Usage:
  $0 start <if> <ip_range> <routes> [host-defs]
  $0 stop <if>

Arguments:
  if:		network interface, e.g., eth0
  ip_range:	first,last IP, e.g.:
		192.168.1.20,192.168.1.50
  routes:	comma-separated routes, e.g.:
		0.0.0.0/0,192.168.1.1,192.168.2.0/24,192.168.1.1
  host_defs:	space-separated MAC,IP host definitions, e.g.:
		52:54:00:00:00:02,192.168.1.2 52:54:00:00:00:03,192.168.1.3
Examples:
  $0 start eth1 192.168.1.20,192.168.1.50 0.0.0.0/0,192.168.1.1 \\
	52:54:00:00:00:02,192.168.1.2 \\
	52:54:00:00:00:03,192.168.1.3

  $0 stop eth1
"

# start dnsmasq
function start_dnsmasq {
	# make sure parameters are there
	if [ -z "$IF" ] || [ -z "$IP_RANGE" ] || [ -z "$ROUTES" ]; then
		echo "$USAGE"
		exit 1
	fi

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
	shift 4
	for i in "${@}"
	do
		CMD_LINE="$CMD_LINE --dhcp-host=$i"
	done

	# make sure pid_dir and pid_file exist
	if [ ! -e "$PID_DIR" ]; then
		mkdir -p "$PID_DIR"
	fi
	if [ ! -e "$PID_FILE" ]; then
		touch "$PID_FILE"
	fi

	# run the command
	$CMD_LINE
}

# stop dnsmasq
function stop_dnsmasq {
	# make sure parameters are there
	if [ -z "$IF" ]; then
		echo "$USAGE"
		exit 1
	fi

	# read pid from pid file
	pid=$(cat "$PID_FILE")
	if [ -z "$pid" ]; then
		echo "could not get dnsmasq pid"
		exit 1
	fi

	# kill pid
	echo "Stopping dnsmasq process with pid $pid"
	kill "$pid"
}

CMD=$1
case $CMD in
"start")
	start_dnsmasq "$@"
	;;
"stop")
	stop_dnsmasq
	;;
*)
	echo "$USAGE"
	;;
esac
