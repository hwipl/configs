#!/bin/bash

SERVER_IP=$1
CLIENT_IP=$2
KEY_NAME=$3

LINES="# Server configuration
dev tun
ifconfig $SERVER_IP $CLIENT_IP
ca ca.crt
cert $KEY_NAME.crt
key $KEY_NAME.key
dh dh.pem
keepalive 10 60
ping-timer-rem
persist-tun
persist-key
user nobody
group nobody
daemon"

echo "$LINES"
