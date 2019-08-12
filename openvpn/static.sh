#!/bin/bash

# public server address for ovpn connection
SERVER_ADDRESS=$1

# shared secret key
KEY_FILE=$2

# vpn internal IP addresses
SERVER_IP=$3
CLIENT_IP=$4

# other scripts
GENKEY_SCRIPT=./genkey.sh
SERVER_SCRIPT=./static_server.sh
CLIENT_SCRIPT=./static_client.sh

FOLDER="static-$SERVER_ADDRESS"

mkdir "$FOLDER"
$GENKEY_SCRIPT "$FOLDER/$KEY_FILE"
$SERVER_SCRIPT \
	"$SERVER_IP" \
	"$CLIENT_IP" \
	"$KEY_FILE" \
	> "$FOLDER/server.ovpn"
$CLIENT_SCRIPT \
	"$SERVER_ADDRESS" \
	"$SERVER_IP" \
	"$CLIENT_IP" \
	"$KEY_FILE" \
	> "$FOLDER/client.ovpn"
