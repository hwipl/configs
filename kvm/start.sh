#!/bin/bash

BR_SCRIPT=./bridge.sh
DNSMASQ_SCRIPT=./dnsmasq.sh
VM_SCRIPT=./kvm.sh

# start vm bridge
$BR_SCRIPT vmbr0 10.10.10.1/24

# start dnsmasq on bridge interface
$DNSMASQ_SCRIPT vmbr0 10.10.10.2 10.10.10.254

# start vm(s)
$VM_SCRIPT vm0.qcow2 vmtap0
