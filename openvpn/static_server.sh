#!/bin/bash

SERVER_IP=$1
CLIENT_IP=$2
KEY_FILE=$3

LINES="# Server configuration
dev tun
ifconfig $SERVER_IP $CLIENT_IP
secret $KEY_FILE"

echo "$LINES"
