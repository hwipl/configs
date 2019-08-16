#!/bin/bash

ETC=/etc/dovecot
DOVECOTCONF=/usr/share/doc/dovecot/example-config/dovecot.conf
CONFD=/usr/share/doc/dovecot/example-config/conf.d

CP=/usr/bin/cp

$CP $DOVECOTCONF $ETC 
$CP -r $CONFD $ETC

# uncomment ssl_dh line in $CONFD/10-ssl.conf
sed -i "/ssl_dh \= <\/etc\/dovecot\/dh.pem/s/^#//" $CONFD/10-ssl.conf
