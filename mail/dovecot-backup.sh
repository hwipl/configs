#!/bin/bash

# command line arguments
CMD=$1

# settings
DATE=$(/usr/bin/date --iso-8601)
BACKUP_DIR=mail-backup
BACKUP_FILE=mail-backup-${DATE}.tar.gz
BACKUP_FMT=sdbox
BACKUP_DEST=$BACKUP_FMT:$BACKUP_DIR

# other programs
DOVEADM=/usr/bin/doveadm
TAR=/usr/bin/tar

# usage
USAGE="$0 - backup current user's mail

Usage:
    $0 run
    $0 tar
Arguments:
    run: backup current user's mail to backup directory.
         Backup directory is $BACKUP_DIR.
	 If you keep it, subsequent backups run faster
	 because only the changes since the last backup
	 call are backed up.
    tar: create a tar archive of backup directory.
         Tar archive is $BACKUP_FILE.

After running \"run\" and/or \"tar\", make sure to copy the
backup directory and/or tar archive to a safe location."

# backup current user's mail to a (temporary) folder
function backup_mail {
	echo "Backing up your mail to $BACKUP_DEST."
	$DOVEADM backup $BACKUP_DEST
}

# make a tar archive of backed up mail
function make_tar {
	echo "Creating tar archive $BACKUP_FILE."
	if [ ! -d "$BACKUP_DIR" ]; then
		echo "\"$BACKUP_DIR\" does not exists. Did you run \"$0 run\"?"
		exit
	fi
	$TAR cpfz "$BACKUP_FILE" "$BACKUP_DIR"
}

# parse command line arguments
case "$CMD" in
	"run")
		backup_mail
		;;
	"tar")
		make_tar
		;;
	*)
		echo "$USAGE"
		;;
esac
