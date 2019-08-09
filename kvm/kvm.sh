#!/bin/bash

IMG=$1
TAP=$2
QEMU=/usr/bin/qemu-system-x86_64
UP=qemu-ifup.sh
DOWN=qemu-ifdown.sh

CMD_LINE="$QEMU"
CMD_LINE="$CMD_LINE -enable-kvm"
CMD_LINE="$CMD_LINE -m 512"
CMD_LINE="$CMD_LINE -drive file=$IMG,if=virtio"
CMD_LINE="$CMD_LINE -netdev tap,id=net0,ifname=$TAP,script=$UP,downscript=$DOWN"

CMD_LINE="$CMD_LINE -device virtio-net-pci,netdev=net0"
if [ -n "$3" ]; then
	# mac specified, append to -device line
	MAC=$3
	CMD_LINE="$CMD_LINE,mac=$MAC"
fi

$CMD_LINE
