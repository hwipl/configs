#!/bin/bash

SERVER_ADDRESS=$1
SERVER_IP=$2
CLIENT_IP=$3
KEY_NAME=$4

LINES="# Client configuration
remote $SERVER_ADDRESS
dev tun
ifconfig $CLIENT_IP $SERVER_IP
ca ca.crt
cert $KEY_NAME.crt
key $KEY_NAME.key
keepalive 10 60
ping-timer-rem
persist-tun
persist-key
user nobody
group nobody
daemon"

echo "$LINES"
