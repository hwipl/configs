#!/bin/bash

FOLDER=$1
NAME=$2
OPTS=$3

EASYRSA=/usr/bin/easyrsa

cd "$FOLDER" || exit

# create server certificate and diffie hellman parameters
$EASYRSA build-server-full "$NAME" "$OPTS"
$EASYRSA gen-dh

# copy files to server's directory
mkdir "$NAME"
cp pki/ca.crt "$NAME"
cp pki/issued/"$NAME".crt "$NAME"
cp pki/private/"$NAME".key "$NAME"
cp pki/dh.pem "$NAME"
