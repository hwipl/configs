#!/bin/bash

FOLDER=$1
NAME=$2
OPTS=$3

EASYRSA=/usr/bin/easyrsa

cd "$FOLDER" || exit

# create client certificate
$EASYRSA build-client-full "$NAME" "$OPTS"

# copy files to server's directory
mkdir "$NAME"
cp pki/ca.crt "$NAME"
cp pki/issued/"$NAME".crt "$NAME"
cp pki/private/"$NAME".key "$NAME"
