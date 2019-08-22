#!/bin/bash

CONFIG=$1
SERVER_NAME=$2
TARGET_NAME=$3

CONFDIR=/etc/openvpn/server

CP=/usr/bin/cp
LN=/usr/bin/ln
SYSTEMCTL=/usr/bin/systemctl

if [ -z "$3" ]; then
       TARGET_NAME=$SERVER_NAME
fi

if [ -e "$CONFDIR/$TARGET_NAME.conf" ]; then
	echo "$CONFDIR/$TARGET_NAME.conf already exists."
	exit
fi

if [ -e "$CONFDIR/$TARGET_NAME" ]; then
	echo "$CONFDIR/$TARGET_NAME already exists."
	exit
fi

$CP -r "$CONFIG/$SERVER_NAME" "$CONFDIR/$TARGET_NAME"
$LN -s "$CONFDIR/$TARGET_NAME/$SERVER_NAME.ovpn" "$CONFDIR/$TARGET_NAME.conf"

# change paths in config
for i in "ca" "cert" "key" "dh"; do
	sed -ri "s|^$i\s+(\w+)|$i $CONFDIR/$TARGET_NAME/\1|" \
		"$CONFDIR/$TARGET_NAME.conf"
done

$SYSTEMCTL enable "openvpn-server@$TARGET_NAME"
$SYSTEMCTL start "openvpn-server@$TARGET_NAME"
