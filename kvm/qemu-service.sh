#!/bin/bash

# command line arguments
CMD=$1

# service file settings
SERVICE_NAME=qemu-custom
SERVICE_DIR=/etc/systemd/system
SERVICE_FILE=$SERVICE_DIR/$SERVICE_NAME@.service

CONF_DIR=/etc/conf.d/qemu.d
QEMU_ENABLE="$0 enable"
QEMU_SERVICE="$0 add"

SERVICE_TEMPLATE="# qemu service configuration
[Unit]
Description=QEMU custom VM service
After=tmp.mount syslog.target network.target

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=$CONF_DIR/%i
ExecStart=$CONF_DIR/%i/start.sh
ExecStop=$CONF_DIR/%i/stop.sh
TimeoutStopSec=60
KillMode=none

[Install]
WantedBy=multi-user.target
"

SERVICE_HINT="Writing service file to $SERVICE_FILE

The service file allows starting a single or multiple VMs and
executing additional configuration commands, e.g., starting a bridge.

Usage of this service file:
* For each of your (single VM or multiple VMs) configurations,
  create a subdirectory in $CONF_DIR named <name>.
* Put start.sh and stop.sh in $CONF_DIR/<name>/
* Optionally, put extra files/scripts into $CONF_DIR/<name>/
* Enable service(s) with systemctl enable $SERVICE_NAME@<name>.service

See $QEMU_ENABLE for a helper for these steps."

# enable settings
SCRIPTS="
../net/add_route.sh
../net/forward_port.sh
bridge.sh
dnsmasq.sh
kvm.sh
nat.sh
qemu-ifdown.sh
qemu-ifup.sh
start.sh
stop.sh"

NAME=$2
SERVICE=$SERVICE_NAME@$NAME.service

SED_ROUTE="s|ADD_ROUTE=../net/add_route.sh|ADD_ROUTE=./add_route.sh|"
SED_FWD="s|FORWARD_PORT=../net/forward_port.sh|FORWARD_PORT=./forward_port.sh|"

ENABLE_INSTRUCT="
If everything worked, service $SERVICE should be ready.
Use systemctl to control it, e.g.:
systemctl enable $SERVICE"

ENABLE_SERVICE="
If you want to enable the service $SERVICE now, answer yes (lowercase) below.
"

# external programs
CP=/usr/bin/cp
SYSTEMCTL=/usr/bin/systemctl

# usage
USAGE="$0 - add and enable qemu systemd services

Usage:
    $QEMU_SERVICE
    $QEMU_ENABLE <name>
Arguments:
    add:    add the qemu service file $SERVICE_DIR
    enable: enable a qemu service for a vm configuration
    name:   name of the virtual machine(s) configuration"

# add the service file to the systemd service directory
function add_service_file {
	if [ -e "$SERVICE_FILE" ]; then
		echo "$SERVICE_FILE aleady exists."
		exit
	fi

	echo "$SERVICE_HINT"
	echo "$SERVICE_TEMPLATE" > "$SERVICE_FILE"
}

# enable a specific service
function enable_service {
	CONF_DIR=$CONF_DIR/$NAME

	if [ -z "$NAME" ]; then
		echo "$USAGE"
		exit
	fi

	if [ ! -e "$SERVICE_FILE" ]; then
		echo "$SERVICE_FILE does not exist. Did you run $QEMU_SERVICE?"
		exit
	fi

	if [ -e "$CONF_DIR" ]; then
		echo "$CONF_DIR already exists."
		exit
	fi

	mkdir -p "$CONF_DIR"

	for i in $SCRIPTS; do
		echo "Copying $i to $CONF_DIR."
		$CP "$i" "$CONF_DIR"
	done

	# correct paths in start.sh and stop.sh
	for i in "$CONF_DIR/start.sh" "$CONF_DIR/stop.sh"; do
		echo "Correcting script paths in $i"
		sed -i "$SED_ROUTE" \
			"$CONF_DIR/start.sh"
		sed -i "$SED_FWD" \
			"$CONF_DIR/start.sh"
	done

	# print further instructions
	echo "$ENABLE_INSTRUCT"

	# enable the systemd service?
	echo "$ENABLE_SERVICE"
	read -rp "Enable the systemd service [yes/NO]? " yesno
	if [ "$yesno" == "yes" ]; then
		echo "Enabling systemd service $SERVICE."
		$SYSTEMCTL enable "$SERVICE"
	fi
}

# run commands depending on command line arguments
case "$CMD" in
	"add")
		add_service_file
		;;
	"enable")
		enable_service
		;;
	*)
		echo "$USAGE"
		;;
esac
