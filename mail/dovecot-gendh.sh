#!/bin/bash

OPENSSL=/usr/bin/openssl
DH_FILE=/etc/dovecot/dh.pem
DH_BITS=4096

if [ -f "$DH_FILE" ]; then
	echo "$DH_FILE already exists."
	exit
fi
$OPENSSL dhparam -out $DH_FILE $DH_BITS
