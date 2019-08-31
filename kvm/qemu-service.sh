#!/bin/bash

SERVICE_NAME=qemu-custom
SERVICE_DIR=/etc/systemd/system
SERVICE_FILE=$SERVICE_DIR/$SERVICE_NAME@.service

CONF_DIR=/etc/conf.d/qemu.d

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

echo "Writing service file to $SERVICE_FILE"
echo "For each of your VMs, create a subdirectory in $CONF_DIR named <vm_name>"
echo "Put start.sh and stop.sh in $CONF_DIR/<vm_name>/"
echo "Optionally, put extra files/scripts into $CONF_DIR/<vm_name>/"
echo "Enable service(s) with systemctl enable $SERVICE_NAME@<vm_name>.service"
echo "$TEMPLATE" > "$SERVICE_FILE"
