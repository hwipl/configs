# net

Networking scripts:

`add_route.sh`: add a route to a network prefix via a router (gateway) to a
device:

```
Usage:
    ./add_route.sh <prefix> <gateway> <dev> [stop]
Arguments:
    prefix:  route this network prefix
    gateway: route via this gateway
    dev:     use this net device for route
    stop:    stop this routing rule
```

`forward_port.sh`: forward a port to a destination IP and port:

```
Usage:
    ./forward_port.sh <port> <dest_ip> <dest_port> [stop]
Arguments:
    port:      external port
    dest_ip:   internal forwarding IP
    dest_port: internal forwarding port
    stop:      stop this forwarding rule
```

`enable_ip_forwarding.sh`: enable IP forwarding for IPv4 persistently by
creating a sysctl configuration file in `/etc/sysctl.d/90-ip-forward.conf` and
loading it.
