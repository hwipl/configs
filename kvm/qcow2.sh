#!/bin/bash

# command line arguments
CMD=$1

# specify ndb device and partition; assume first device and partition
NBD_DEV=/dev/nbd0
NBD_PART=${NBD_DEV}p1

# other programs
QEMU_IMG=/usr/bin/qemu-img
QEMU_NBD=/usr/bin/qemu-nbd
MODPROBE=/usr/bin/modprobe
MOUNT=/usr/bin/mount
UMOUNT=/usr/bin/umount

# usage
USAGE="Usage:
    $0 create <img_name> <img_size>
    $0 mount <img_name> <dir>
    $0 umount <img_name> <dir>
Arguments:
    img_name: name of the qcow2 image
    img_size: size of the qcow2 image
    dir:      directory name for (un)mount"

# create
function create {
	img_name=$1
	img_size=$2

	# make sure parameters are there
	if [ -z "$img_name" ] || [ -z "$img_size" ]; then
		echo "$USAGE"
		exit
	fi

	# make sure file does not exist
	if [ -e "$img_name" ]; then
		echo "$img_name already exists."
		exit
	fi

	echo "Creating new image $img_name with size $img_size"
	$QEMU_IMG create -f qcow2 "$img_name" "$img_size"
}

# mount
function mount {
	img_name=$1
	dir=$2

	# make sure parameters are there
	if [ -z "$img_name" ] || [ -z "$dir" ]; then
		echo "$USAGE"
		exit
	fi

	# make sure file exists
	if [ ! -f "$img_name" ];then
		exit
	fi

	# if mount dir does not exist, create it
	if [ ! -e "$dir" ]; then
		mkdir "$dir"
	fi

	# if mount dir is not a directory, exit
	if [ ! -d "$dir" ]; then
		echo "$dir is not a directory."
		exit
	fi

	echo "Mounting image $img_name in $dir"
	$MODPROBE nbd
	$QEMU_NBD --connect=$NBD_DEV "$img_name"
	$MOUNT $NBD_PART "$dir"
}

# umount
function umount {
	img_name=$1
	dir=$2

	# make sure parameters are there
	if [ -z "$img_name" ] || [ -z "$dir" ]; then
		echo "$USAGE"
		exit
	fi

	echo "Unmounting image $img_name mounted in $dir"
	$UMOUNT "$dir"
	$QEMU_NBD --disconnect $NBD_DEV
}

# run commands with other command line arguments
case "$CMD" in
	"create")
		create "$2" "$3"
		;;
	"mount")
		mount "$2" "$3"
		;;
	"umount")
		umount "$2" "$3"
		;;
	*)
		echo "$USAGE"
		;;
esac
