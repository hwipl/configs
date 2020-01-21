#!/bin/bash

LDACONF=/etc/dovecot/conf.d/15-lda.conf
LMTPCONF=/etc/dovecot/conf.d/20-lmtp.conf

# check if config files exist
if [ ! -f "$LDACONF" ] && [ ! -f "$LMTPCONF" ]; then
	echo "Configs do not exist."
	exit
fi

# check if sieve is already configured
REGEX="^[[:space:]]*mail_plugins[[:space:]]*=[[:space:]]*"
REGEX="$REGEX\$mail_plugins.*sieve.*"

# check lda config
if grep "$REGEX" $LDACONF > /dev/null; then
	echo "Sieve already enabled in $LDACONF."
	exit
fi

# check lmtp config
if grep "$REGEX" $LMTPCONF > /dev/null; then
	echo "Sieve already enabled in $LMTPCONF."
	exit
fi

# add sieve to configs
echo "Trying to enable sieve in $LDACONF and $LMTPCONF.

This assumes there is a line starting with either
    #mail_plugins = \$mail_plugins
or
    mail_plugins = \$mail_plugins
"

# uncomment mail_plugins line if it exists
sed -i "/#mail_plugins \= \$mail_plugins/s/#//" $LDACONF
sed -i "/#mail_plugins \= \$mail_plugins/s/#//" $LMTPCONF

# append sieve to the end of mail_plugins line
sed -i "/mail_plugins \= \$mail_plugins/ s/\$/ sieve/" $LDACONF
sed -i "/mail_plugins \= \$mail_plugins/ s/\$/ sieve/" $LMTPCONF

# done
echo "Please make sure your $LDACONF and $LMTPCONF are correct,
especially if you edited them before running this script.
"
