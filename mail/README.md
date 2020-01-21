# mail

This folder contains scripts for creating a simple mail server configuration
with dovecot and getmail.

## dovecot

`dovecot.sh`: create a configuration for a dovecot server: create an openssl
configuration (with `dovecot-genopensslcnf.sh`), create a SSL certificate (with
`dovecot-gencert.sh`), create DH parameters (with `dovecot-gendh.sh`), and
create configuration files (with `dovecot-genconfig.sh`):

```
Usage:
    ./dovecot.sh <common_name> <mail_address>
Arguments:
    common_name:  common name of server for SSL certificate
    mail_address: postmaster mail address for SSL certificate
```

`dovecot-user.sh`: create a new user that belongs to the dovecot group or add
an existing user to the dovecot group, so it can access dovecot:

```
Usage:
    ./dovecot-user.sh <user>
Arguments:
    user: name of the user you want to add/modify
```

`dovecot-backup.sh`: backup the current user's mail to a (temporary) folder and
optionally create a tar archive:

```
./dovecot-backup.sh - backup current user's mail

Usage:
    ./dovecot-backup.sh run
    ./dovecot-backup.sh tar
Arguments:
    run: backup current user's mail to backup directory.
         Backup directory is "mail-backup".
         If you keep it, subsequent backups run faster
         because only the changes since the last backup
         call are backed up.
    tar: create a tar archive of backup directory.
         Tar archive is "mail-backup-2019-09-05.tar.gz".

After running "run" and/or "tar", make sure to copy the
backup directory and/or tar archive to a safe location.
```

`dovecot-sieve.sh`: enable the sieve plugin in the lda and lmtp configuration
files of dovecot, so users can use sieve. `example.dovecot.sieve` is an example
of a `.dovecot.sieve` file that can be put in a user's home directory.

## getmail

`getmail-genrc.sh`: generate a getmailrc for a mail account in `~/.getmail/`:

```
Usage:
    ./getmail-genrc.sh <name> <server> <username> <password>
Arguments:
    name:     name of configuration
    server:   address of mail server
    username: username of account on mail server
    password: password of account on mail server
```

`getmail-crontab.sh`: generate a crontab for one or more getmailrcs in
`~/.getmail/` and print it to stdout:

```
Usage:
    ./getmail-crontab.sh <getmailrc> [getmailrc...]
Arguments:
    getmailrc: getmail configuration file in ~/.getmail/
```

`getmail-timer.sh`: enable user specific systemd timers for one or more
getmailrcs in `~./getmail/`:

```
./getmail-timer.sh - Enable user systemd timer(s) for getmail

Usage:
    ./getmail-timer.sh <getmailrc> [getmailrc...]
Arguments:
    getmailrc: getmail configuration file in ~/.getmail/
```
