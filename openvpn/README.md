# openvpn

This folder contains scripts for creating a simple openvpn configuration with
either static keys or public keys.

## static keys

`static.sh`: create a static key configuration: create a shared secret key
(with `static_genkey.sh`), create a server configuration file (with
`static_server.sh`), and create a client configuration file (with
`static_client.sh`):

```
Usage:
  ./static.sh <server_address> <key_file> <server_ip> <client_ip>
Mandatory arguments:
  server_address:   server's vpn external address for vpn tunnel
  key_file:         file for shared secret key
  server_ip:        vpn internal ip address of server
  client_ip:        vpn internal ip address of client
```

## public keys

`public.sh`: create a public key configuration: create a certificate authority
(with `pubkey_genca.sh`), create a server certificate and DH parameters (with
`pubkey_genserver.sh`), create a server configuration file (with
`pubkey_server.sh`), create a client certificate (with `pubkey_genclient.sh`),
and create a client configuration file (with `pubkey_client.sh`):

```
Usage:
  ./pubkey.sh <server_address> <server_ip> <server_netmask> [nopass]
Mandatory arguments:
  server_address:   server's vpn external address for vpn tunnel
  server_ip:        vpn internal ip address of server
  server_netmask:   vpn internal netmask of server
Optional arguments:
  nopass:           do not use passwords for keys
```

## systemd services

`enable_client.sh`: copy client configuration to `/etc/openvpn/client`, adapt
paths in configuration file, enable and start systemd service:

```
Usage:
  ./enable_client.sh <config> <client> [target]
Arguments:
  config: name of openvpn configuration folder, that contains client config
  client: name of client configuration in configuration folder
  target: name of target configuration in "/etc/openvpn/client"
```

`enable_server.sh`: copy server configuration to `/etc/openvpn/server`, adapt
paths in configuration file, enable and start systemd service.

```
Usage:
  ./enable_server.sh <config> <server> [target]
Arguments:
  config: name of openvpn configuration folder, that contains server config
  server: name of server configuration in configuration folder
  target: name of target configuration in "/etc/openvpn/server"
```
