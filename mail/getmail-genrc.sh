#!/bin/bash

# command line arguments
NAME=$1
SERVER=$2
USERNAME=$3
PASSWORD=$4

# path definitions
CONF_PATH=~/.getmail
LOG_PATH="$CONF_PATH/$NAME.log"

DELIVER_PATH=/usr/lib/dovecot/deliver

# template configuration
CONFIG="# getmail configuration
[retriever]
type = SimplePOP3SSLRetriever
server = $SERVER
username = $USERNAME
password = $PASSWORD

[destination]
type = MDA_external
path = $DELIVER_PATH
arguments = (\"-e\",)
# if you want to move mails to a certain imap folder, use -m option like below
# arguments = (\"-e\", \"-m\", \"some/folder\")

[options]
read_all = false
delete = false
# if you want to delete old mails after, e.g., 30 days, uncomment next line
# delete_after = 30
received = false
delivered_to = false
message_log = $LOG_PATH
"

# print usage if not all arguments are present
if [ "$#" -lt 4 ]; then
	echo "Usage:"
	echo "    $0 <name> <server> <username> <password>"
	echo "Arguments:"
	echo "    name:     name of configuration"
	echo "    server:   address of mail server"
	echo "    username: username of account on mail server"
	echo "    password: password of account on mail server"
	exit
fi

# create config directory if necessary
if [ ! -e "$CONF_PATH" ]; then
	mkdir $CONF_PATH
fi

# check if config file already exists
if [ -e "$CONF_PATH/$NAME" ]; then
	echo "$CONF_PATH/$NAME already exists."
	exit
fi

# write config to file
echo "$CONFIG" > "$CONF_PATH/$NAME"
