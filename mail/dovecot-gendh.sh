#!/bin/bash

OPENSSL=/usr/bin/openssl
DH_FILE=/etc/dovecot/dh.pem
DH_BITS=4096

$OPENSSL dhparam -out $DH_FILE $DH_BITS
