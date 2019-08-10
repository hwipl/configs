#!/bin/bash

# scripts
BR_SCRIPT=./bridge.sh
DNSMASQ_SCRIPT=./dnsmasq.sh
NAT_SCRIPT=./nat.sh
VM_SCRIPT=./kvm.sh

# bridge config
BRIDGE_PREFIX=10.10.10.0/24
BRIDGE_IP=10.10.10.1/24

# dhcp config
DYNIP_START=10.10.10.20
DYNIP_END=10.10.10.254

# VM config
VM0_MAC=52:54:00:00:00:02
VM0_IP=10.10.10.2

# start vm bridge
$BR_SCRIPT vmbr0 $BRIDGE_IP

# start dnsmasq on bridge interface
$DNSMASQ_SCRIPT vmbr0 $DYNIP_START,$DYNIP_END \
	$VM0_MAC,$VM0_IP

# enable nat and ip forwarding on bridge interface
$NAT_SCRIPT vmbr0 $BRIDGE_PREFIX

# start vm(s)
$VM_SCRIPT 0 vm0.qcow2 vmtap0 $VM0_MAC
