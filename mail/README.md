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
     <getmailrc> [getmailrc...]
Arguments:
    getmailrc: getmail configuration file in ~/.getmail/
```
