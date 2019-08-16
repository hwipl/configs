#!/bin/bash

# common name, e.g., imap.example.com or *.example.com
COMMON_NAME=$1

# Mail address of postmaster, e.g., postmaster@example.com
EMAIL_CONTACT=$2

# destination openssl config file
SSLCNF=/etc/ssl/dovecot-openssl.cnf

# dovecot-openssl.cnf based on /usr/share/doc/dovecot/dovecot-openssl.cnf
CONFIG="# dovecot-openssl.cnf:
# * copy this file into folder /etc/ssl/
# * create cert with /usr/lib/dovecot/mkcert.sh

[ req ]
default_bits = 1024
encrypt_key = yes
distinguished_name = req_dn
x509_extensions = cert_type
prompt = no

[ req_dn ]
# country (2 letter code)
#C=FI

# State or Province Name (full name)
#ST=

# Locality Name (eg. city)
#L=Helsinki

# Organization (eg. company)
#O=Dovecot

# Organizational Unit Name (eg. section)
OU=IMAP server

# Common Name (*.example.com is also possible)
CN=$COMMON_NAME

# E-mail contact
emailAddress=$EMAIL_CONTACT

[ cert_type ]
nsCertType = server

# end of dovecot-openssl.cnf"

echo "$CONFIG" > $SSLCNF
