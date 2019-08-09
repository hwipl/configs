#!/bin/bash

BR_SCRIPT=./bridge.sh
VM_SCRIPT=./kvm.sh

# start vm bridge
$BR_SCRIPT vmbr0

# start vm(s)
$VM_SCRIPT vm0.qcow2 vmtap0
