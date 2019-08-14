#!/bin/bash

# public server address for ovpn connection
SERVER_ADDRESS=$1

# vpn internal IP addresses
SERVER_IP=$2
SERVER_NETMASK=$3

# other scripts
GENCA_SCRIPT=./pubkey_genca.sh
GENSERVER_SCRIPT=./pubkey_genserver.sh
GENCLIENT_SCRIPT=./pubkey_genclient.sh
SERVER_SCRIPT=./pubkey_server.sh
CLIENT_SCRIPT=./pubkey_client.sh

FOLDER="pubkey-$SERVER_ADDRESS"

mkdir "$FOLDER"
$GENCA_SCRIPT "$FOLDER"
$GENSERVER_SCRIPT "$FOLDER" server
$SERVER_SCRIPT \
	"$SERVER_IP" \
	"$SERVER_NETMASK" \
	"server" \
	> "$FOLDER/server/server.ovpn"
$GENCLIENT_SCRIPT "$FOLDER" client
$CLIENT_SCRIPT \
	"$SERVER_ADDRESS" \
	"client" \
	> "$FOLDER/client/client.ovpn"
