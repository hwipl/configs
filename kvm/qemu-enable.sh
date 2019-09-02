#!/bin/bash

NAME=$1

CONF_DIR=/etc/conf.d/qemu.d/$NAME
SERVICE_NAME=qemu-custom
SERVICE_DIR=/etc/systemd/system
SERVICE_FILE=$SERVICE_DIR/$SERVICE_NAME@.service
SERVICE=$SERVICE_NAME@$NAME.service
QEMU_SERVICE=qemu-service.sh

CP=/usr/bin/cp
SYSTEMCTL=/usr/bin/systemctl

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

if [ "$#" -lt 1 ]; then
	echo "Usage:"
	echo "    $1 <name>"
	echo "Arguments:"
	echo "    name: name of virtual machine(s) configuration"
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

# correct paths in start.sh
echo "Correcting script paths in $CONF_DIR/start.sh"
sed -i "s|ADD_ROUTE=../net/add_route.sh|ADD_ROUTE=./add_route.sh|" \
	"$CONF_DIR/start.sh"
sed -i "s|FORWARD_PORT=../net/forward_port.sh|FORWARD_PORT=./forward_port.sh|" \
	"$CONF_DIR/start.sh"

# print further instructions
echo "
If everything worked, service $SERVICE should be ready.
Use systemctl to control it, e.g.:
systemctl enable $SERVICE"

# enable the systemd service?
echo "
If you want to enable the service $SERVICE now, answer yes (lowercase) below.
"
read -rp "Enable the systemd service [yes/NO]? " yesno
if [ "$yesno" == "yes" ]; then
	echo "Enabling systemd service $SERVICE."
	$SYSTEMCTL enable "$SERVICE"
fi
