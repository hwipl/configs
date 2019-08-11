# KVM Scripts

This folder contains KVM scripts for running virtual machines on a host that
are interconnected by a software bridge. The software bridge allows traffic
from VMs to go to the Internet via a NAT gateway. Also, VMs can get fixed IP
addresses from a DHCP server with mappings from VM MAC addresses to IP
addresses.

The scripts are used for:
* creating a software bridge,
* starting dnsmasq for DHCP and DNS on the software bridge,
* using iptables to enable NAT of traffic coming from the bridge, and
* starting virtual machines.

## bridge.sh

Script for starting the software bridge.

## dnsmasq.sh

Script for running dnsmasq on the bridge. Dnsmasq enables DHCP and DNS on the
bridge. DHCP host entries assign specific IP addresses to specific MAC
addresses

## nat.sh

Script for configuring NAT of traffic coming from the bridge with iptables.

## kvm.sh and qemu-ifup/ifdown.sh

Script for starting virtual machines (kvm.sh) and setting up the virtual
network devices in the host when the VMs are started/stopped (qemu-ifup.sh,
qemu-ifdown.sh).

## start.sh

Script calling all other scripts and starting everything.
