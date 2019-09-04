#!/bin/sh

# certificate common name and postmaster mail address
COMMON_NAME=$1
MAIL_ADDRESS=$2

# other scripts
GENSSLCNF=./dovecot-genopensslcnf.sh
GENCERT=./dovecot-gencert.sh
GENDH=./dovecot-gendh.sh
GENCONFIG=./dovecot-genconfig.sh

if [ "$#" -lt 2 ]; then
	echo "Usage:"
	echo "    $0 <common_name> <mail_address>"
	echo "Arguments:"
	echo "    common_name:  common name of server for SSL certificate"
	echo "    mail_address: postmaster mail address for SSL certificate"
	exit
fi

$GENSSLCNF "$COMMON_NAME" "$MAIL_ADDRESS"
$GENCERT
$GENDH
$GENCONFIG
