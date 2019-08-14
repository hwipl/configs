#!/bin/bash

FOLDER=$1

EASYRSA=/usr/bin/easyrsa

mkdir "$FOLDER"
cd "$FOLDER" || exit

# create pki and ca
$EASYRSA init-pki
cp -r /etc/easy-rsa/* pki
$EASYRSA build-ca
