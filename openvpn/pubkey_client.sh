#!/bin/bash

SERVER_ADDRESS=$1
KEY_NAME=$2

LINES="# Client configuration
client
remote $SERVER_ADDRESS
dev tun
ca ca.crt
cert $KEY_NAME.crt
key $KEY_NAME.key
keepalive 10 60
ping-timer-rem
persist-tun
persist-key
# uncomment if your ovpn does not run as unprivileged user
# user nobody
# group nobody
daemon"

echo "$LINES"
