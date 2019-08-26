#!/bin/bash

VNC=$1
IMG=$2
TAP=$3
QEMU=/usr/bin/qemu-system-x86_64
UP=qemu-ifup.sh
DOWN=qemu-ifdown.sh

# folder for unix socket files for monitor access
SOCK_DIR=/tmp/qemu-VMs

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

# random generator device
CMD_LINE="$CMD_LINE -object rng-random,filename=/dev/urandom,id=rng0"
CMD_LINE="$CMD_LINE -device virtio-rng-pci,rng=rng0"

# make monitor accessible via unix socket
if [ ! -e "$SOCK_DIR" ]; then
	mkdir "$SOCK_DIR"
fi
CMD_LINE="$CMD_LINE -monitor unix:$SOCK_DIR/monitor$VNC.sock,server,nowait"

$CMD_LINE
