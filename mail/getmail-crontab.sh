#!/bin/bash

# GETMAIL_CONFIGS=$1
GETMAIL_FOLDER=~/.getmail/
GETMAIL=getmail

# set intervall to retrieve mail every 5 minutes
INTERVALL=5

if [ "$#" -lt 1 ]; then
	echo "Usage:"
	echo "    $1 <getmailrc> [getmailrc...]"
	echo "Arguments:"
	echo "    getmailrc: getmail configuration file in ~/getmail/"
	exit
fi

echo "# retrieve mails every 5 minutes"
for i in "$@"; do
	echo "*/$INTERVALL * * * * $GETMAIL -q -g $GETMAIL_FOLDER -r $i"
done
