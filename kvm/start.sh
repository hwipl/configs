#!/bin/bash

# scripts
BR_SCRIPT=./bridge.sh
DNSMASQ_SCRIPT=./dnsmasq.sh
NAT_SCRIPT=./nat.sh
VM_SCRIPT=./kvm.sh

# bridge config
BRIDGE_PREFIX=10.10.10.0/24
BRIDGE_IP=10.10.10.1/24
# configure default and additional routes on vms via dhcp
BRIDGE_DEFAULT_ROUTE=0.0.0.0/0,10.10.10.1
BRIDGE_ADD_ROUTES=10.10.11.0/24,10.10.10.2
BRIDGE_ROUTES=$BRIDGE_DEFAULT_ROUTE,$BRIDGE_ADD_ROUTES

# dhcp config
DYNIP_START=10.10.10.20
DYNIP_END=10.10.10.254

# VM config
VM0_MAC=52:54:00:00:00:02
VM0_IP=10.10.10.2
VM1_MAC=52:54:00:00:00:03
VM1_IP=10.10.10.3
VM2_MAC=52:54:00:00:00:04
VM2_IP=10.10.10.4
VM3_MAC=52:54:00:00:00:05
VM3_IP=10.10.10.5

# start vm bridge
$BR_SCRIPT vmbr0 $BRIDGE_IP

# start dnsmasq on bridge interface
$DNSMASQ_SCRIPT vmbr0 $DYNIP_START,$DYNIP_END $BRIDGE_ROUTES \
	$VM0_MAC,$VM0_IP \
	$VM1_MAC,$VM1_IP \
	$VM2_MAC,$VM2_IP \
	$VM3_MAC,$VM3_IP

# enable nat and ip forwarding on bridge interface
$NAT_SCRIPT vmbr0 $BRIDGE_PREFIX

# start vm(s)
$VM_SCRIPT 0 vm0.qcow2 vmtap0 $VM0_MAC
$VM_SCRIPT 1 vm1.qcow2 vmtap1 $VM1_MAC
$VM_SCRIPT 2 vm2.qcow2 vmtap2 $VM2_MAC
$VM_SCRIPT 3 vm3.qcow2 vmtap3 $VM3_MAC
