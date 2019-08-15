#!/bin/bash

FOLDER=$1
OPTS=$2

EASYRSA=/usr/bin/easyrsa

mkdir "$FOLDER"
cd "$FOLDER" || exit

# create pki and ca
$EASYRSA init-pki
cp -r /etc/easy-rsa/* pki
$EASYRSA build-ca "$OPTS"
