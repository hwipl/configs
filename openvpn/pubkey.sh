#!/bin/bash

# public server address for ovpn connection
SERVER_ADDRESS=$1

# vpn internal IP addresses
SERVER_IP=$2
SERVER_NETMASK=$3

# options for certificate creation
OPTS=$4

# other scripts
GENCA_SCRIPT=./pubkey_genca.sh
GENSERVER_SCRIPT=./pubkey_genserver.sh
GENCLIENT_SCRIPT=./pubkey_genclient.sh
SERVER_SCRIPT=./pubkey_server.sh
CLIENT_SCRIPT=./pubkey_client.sh

FOLDER="pubkey-$SERVER_ADDRESS"

if [ -d "$FOLDER" ]; then
	echo "Configuration already exists."
	echo "If you want to create an additional client configuration,"
	echo "enter client name below."
	read -rp "Client name: "  CLIENT_NAME
	if [ "$CLIENT_NAME" == "" ]; then
		exit
	fi
	$GENCLIENT_SCRIPT "$FOLDER" "$CLIENT_NAME" "$OPTS"
	$CLIENT_SCRIPT \
		"$SERVER_ADDRESS" \
		"$CLIENT_NAME" \
		> "$FOLDER/$CLIENT_NAME/client.ovpn"
	exit
fi

mkdir "$FOLDER"
$GENCA_SCRIPT "$FOLDER" "$OPTS"
$GENSERVER_SCRIPT "$FOLDER" server "$OPTS"
$SERVER_SCRIPT \
	"$SERVER_IP" \
	"$SERVER_NETMASK" \
	"server" \
	> "$FOLDER/server/server.ovpn"
$GENCLIENT_SCRIPT "$FOLDER" client "$OPTS"
$CLIENT_SCRIPT \
	"$SERVER_ADDRESS" \
	"client" \
	> "$FOLDER/client/client.ovpn"
