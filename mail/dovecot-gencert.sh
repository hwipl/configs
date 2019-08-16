#!/bin/bash

MKCERT=/usr/lib/dovecot/mkcert.sh
CERT=/etc/ssl/certs/dovecot.pem
TRUST_ANCHOR=/etc/ca-certificates/trust-source/anchors/dovecot.crt

CP=/usr/bin/cp
TRUST=/usr/bin/trust

$MKCERT
$CP $CERT $TRUST_ANCHOR 
$TRUST extract-compat
