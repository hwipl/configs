#!/bin/bash

USER=$1

DOVECOT_GROUP=dovecot

ID=/usr/bin/id
USERMOD=/usr/bin/usermod
USERADD=/usr/bin/useradd

if [ "$#" -lt 1 ]; then
	echo "Usage:"
	echo "    $0 <user>"
	echo "Arguments:"
	echo "    user: name of the user you want to add/modify"
	exit
fi

user_exists=$($ID -u "$USER" > /dev/null 2>&1; echo $?)
 
if [ "$user_exists" -eq 0 ]; then
       	echo "Adding existing user $USER to dovecot group ($DOVECOT_GROUP)."
	$USERMOD -a -G $DOVECOT_GROUP "$USER"
else
	echo "Creating new user $USER."
	$USERADD -m -U -G $DOVECOT_GROUP "$USER"
	echo "Do not forget to set a password with:"
	echo "passwd $USER"
fi

if [ ! -e "/home/$USER/sdbox" ]; then
	echo "Creating dbox mail folder in /home/$USER/sdbox"
	mkdir "/home/$USER/sdbox"
	chmod 600 "/home/$USER/sdbox"
fi
