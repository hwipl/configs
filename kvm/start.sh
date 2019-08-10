#!/bin/bash

BR_SCRIPT=./bridge.sh
DNSMASQ_SCRIPT=./dnsmasq.sh
NAT_SCRIPT=./nat.sh
VM_SCRIPT=./kvm.sh

# start vm bridge
$BR_SCRIPT vmbr0 10.10.10.1/24

# start dnsmasq on bridge interface
$DNSMASQ_SCRIPT vmbr0 10.10.10.20,10.10.10.254 \
	52:54:00:00:00:02,10.10.10.2

# enable nat and ip forwarding on bridge interface
$NAT_SCRIPT vmbr0 10.10.10.0/24

# start vm(s)
$VM_SCRIPT 0 vm0.qcow2 vmtap0 52:54:00:00:00:02
