#!/bin/bash

TYPE=$1
CONFIG=$2
SOURCE_NAME=$3
TARGET_NAME=$4

CONFDIR=/etc/openvpn/$TYPE

CP=/usr/bin/cp
LN=/usr/bin/ln
SYSTEMCTL=/usr/bin/systemctl

USAGE="$0 - Enable an openvpn client or server systemd service

Usage:
  $0 client <config> <name> [target]
  $0 server <config> <name> [target]
Arguments:
  client: enable a client configuration
  server: enable a server configuration
  config: name of openvpn configuration folder, that contains the config
  name:   name of configuration in configuration folder
  target: name of target configuration in \"$CONFDIR\""

if [ "$#" -lt 3 ]; then
        echo "$USAGE"
        exit
fi

if [ -z "$4" ]; then
       TARGET_NAME=$SOURCE_NAME
fi

if [ -e "$CONFDIR/$TARGET_NAME.conf" ]; then
	echo "$CONFDIR/$TARGET_NAME.conf already exists."
	exit
fi

if [ -e "$CONFDIR/$TARGET_NAME" ]; then
	echo "$CONFDIR/$TARGET_NAME already exists."
	exit
fi

$CP -r "$CONFIG/$SOURCE_NAME" "$CONFDIR/$TARGET_NAME"
$LN -s "$CONFDIR/$TARGET_NAME/$SOURCE_NAME.ovpn" "$CONFDIR/$TARGET_NAME.conf"

# change paths in config
for i in "ca" "cert" "key" "dh"; do
	sed -ri "s|^$i\s+(\w+)|$i $CONFDIR/$TARGET_NAME/\1|" \
		"$CONFDIR/$TARGET_NAME.conf"
done

$SYSTEMCTL enable "openvpn-$TYPE@$TARGET_NAME"
$SYSTEMCTL start "openvpn-$TYPE@$TARGET_NAME"
