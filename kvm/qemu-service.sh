#!/bin/bash

SERVICE_NAME=qemu-custom
SERVICE_DIR=/etc/systemd/system
SERVICE_FILE=$SERVICE_DIR/$SERVICE_NAME@.service

CONF_DIR=/etc/conf.d/qemu.d
QEMU_ENABLE=qemu-enable.sh

TEMPLATE="# qemu service configuration
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

if [ -e "$SERVICE_FILE" ]; then
	echo "$SERVICE_FILE aleady exists."
	exit
fi

echo "Writing service file to $SERVICE_FILE

The service file allows starting a single or multiple VMs and
executing additional configuration commands, e.g., starting a bridge.

Usage of this service file:
* For each of your (single VM or multiple VMs) configurations,
  create a subdirectory in $CONF_DIR named <name>.
* Put start.sh and stop.sh in $CONF_DIR/<name>/
* Optionally, put extra files/scripts into $CONF_DIR/<name>/
* Enable service(s) with systemctl enable $SERVICE_NAME@<name>.service

See $QEMU_ENABLE for a helper script for these steps."
echo "$TEMPLATE" > "$SERVICE_FILE"
