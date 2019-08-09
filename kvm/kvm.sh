#!/bin/bash

IMG=$1
TAP=$2
UP=qemu-ifup.sh
DOWN=qemu-ifdown.sh

qemu-system-x86_64 \
	-enable-kvm \
	-m 512 \
	-drive file="$IMG",if=virtio \
	-netdev tap,id=net0,ifname="$TAP",script=$UP,downscript=$DOWN \
	-device virtio-net-pci,netdev=net0
