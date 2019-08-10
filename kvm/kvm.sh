#!/bin/bash

VNC=$1
IMG=$2
TAP=$3
QEMU=/usr/bin/qemu-system-x86_64
UP=qemu-ifup.sh
DOWN=qemu-ifdown.sh

CMD_LINE="$QEMU"
CMD_LINE="$CMD_LINE -enable-kvm"
CMD_LINE="$CMD_LINE -m 512"
CMD_LINE="$CMD_LINE -daemonize"
CMD_LINE="$CMD_LINE -vnc 127.0.0.1:$VNC"
CMD_LINE="$CMD_LINE -drive file=$IMG,if=virtio"
CMD_LINE="$CMD_LINE -netdev tap,id=net0,ifname=$TAP,script=$UP,downscript=$DOWN"

CMD_LINE="$CMD_LINE -device virtio-net-pci,netdev=net0"
if [ -n "$4" ]; then
	# mac specified, append to -device line
	MAC=$4
	CMD_LINE="$CMD_LINE,mac=$MAC"
fi

$CMD_LINE
