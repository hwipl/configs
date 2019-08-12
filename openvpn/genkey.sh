#!/bin/sh

OPENVPN=/usr/bin/openvpn
# file for secret key, e.g., secret.key
KEYFILE=$1

$OPENVPN --genkey --secret "$KEYFILE"
