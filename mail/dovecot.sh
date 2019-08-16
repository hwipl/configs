#!/bin/sh

# certificate common name and postmaster mail address
COMMON_NAME=$1
MAIL_ADDRESS=$2

# other scripts
GENSSLCNF=./dovecot-genopensslcnf.sh
GENCERT=./dovecot-gencert.sh
GENDH=./dovecot-gendh.sh
GENCONFIG=./dovecot-genconfig.sh

$GENSSLCNF "$COMMON_NAME" "$MAIL_ADDRESS"
$GENCERT
$GENDH
$GENCONFIG
