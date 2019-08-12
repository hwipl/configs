#!/bin/bash

SERVER_ADDRESS=$1
SERVER_IP=$2
CLIENT_IP=$3
KEY_FILE=$4

LINES="# Client configuration
remote $SERVER_ADDRESS
dev tun
ifconfig $CLIENT_IP $SERVER_IP
secret $KEY_FILE"

echo "$LINES"
