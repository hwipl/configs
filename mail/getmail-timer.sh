#!/bin/bash

# usage
USAGE="$0 - Enable user systemd timer(s) for getmail

Usage:
    $0 <getmailrc> [getmailrc...]
Arguments:
    getmailrc: getmail configuration file in ~/.getmail/"

# getmail settings
GETMAIL_FOLDER=~/.getmail/
GETMAIL=/usr/bin/getmail

# set intervall to retrieve mail every 5 minutes
INTERVALL=5

# systemd settings
SYSTEMCTL=/usr/bin/systemctl
SYSTEMD_DIR=~/.config/systemd/user
SYSTEMD_PREFIX=getmail
SYSTEMD_SERVICE=$SYSTEMD_DIR/$SYSTEMD_PREFIX@.service
SYSTEMD_TIMER=$SYSTEMD_DIR/$SYSTEMD_PREFIX@.timer

SERVICE_TEMPLATE="[Unit]
Description=Run getmail with specific config file

[Service]
ExecStart=$GETMAIL -q -g $GETMAIL_FOLDER -r %i

[Install]
WantedBy=default.target"

TIMER_TEMPLATE="[Unit]
Description=Run getmail every $INTERVALL minutes

[Timer]
OnActiveSec=${INTERVALL}min
OnUnitActiveSec=${INTERVALL}min

[Install]
WantedBy=timers.target"

# check command line arguments and print usage
if [ "$#" -lt 1 ]; then
	echo "$USAGE"
	exit
fi

# make sure user systemd directory exists
if [ ! -e "$SYSTEMD_DIR" ]; then
	echo "Creating user's systemd directory \"$SYSTEMD_DIR\"."
	mkdir -p "$SYSTEMD_DIR"
fi

# make sure systemd service file exists
if [ ! -e "$SYSTEMD_SERVICE" ]; then
	echo "Creating user's systemd service file \"$SYSTEMD_SERVICE\"."
	echo "$SERVICE_TEMPLATE" > "$SYSTEMD_SERVICE"
fi

# make sure systemd timer file exists
if [ ! -e "$SYSTEMD_TIMER" ]; then
	echo "Creating user's systemd service file \"$SYSTEMD_TIMER\"."
	echo "$TIMER_TEMPLATE" > "$SYSTEMD_TIMER"
fi

# create specific timer(s) for configs specified in command line
for i in "$@"; do
	# make sure config exists
	if [ ! -e "$GETMAIL_FOLDER/$i" ]; then
		echo "Getmail config $i does not exists."
		continue
	fi

	# enable and start timer
	echo "Enabling timer $SYSTEMD_PREFIX@$i.timer."
	$SYSTEMCTL --user enable "$SYSTEMD_PREFIX"@"$i".timer
	echo "Starting timer $SYSTEMD_PREFIX@$i.timer."
	$SYSTEMCTL --user start "$SYSTEMD_PREFIX"@"$i".timer
done

echo "
Notes:
* You can list your active timers with:
  systemctl --user list-timers
* You can control your timers with:
  systemctl --user <cmd> $SYSTEMD_PREFIX@<name>.timer
* You might want to enable lingering for this user, so the timers run
  without the user being logged in:
  loginctl enable-linger <username>"
