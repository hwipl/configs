#!/bin/bash

# configuration
EXT_IF=$2

# dnsmasq
NFT=/usr/bin/nft

# nftables table name
TABLE="nat-$EXT_IF"

# usage
USAGE="Usage:
  $0 start <ext_if>
  $0 stop <ext_if>

Arguments:
  ext_if:	external network interface, e.g.: eth1

Examples:
  $0 start eth1
  $0 stop eth1
"

# start nat
function start_nat {
	# make sure parameters are there
	if [ -z "$EXT_IF" ]; then
		echo "$USAGE"
		exit 1
	fi

	# configure rules
	rules="
table inet $TABLE {
    chain postrouting {
        type nat hook postrouting priority srcnat
        policy accept

        oifname $EXT_IF masquerade
    }
}
"
	$NFT "$rules"
}

# stop nat
function stop_nat {
	# make sure parameters are there
	if [ -z "$EXT_IF" ]; then
		echo "$USAGE"
		exit 1
	fi

	# delete table
	$NFT delete table inet "$TABLE"
}

CMD=$1
case $CMD in
"start")
	start_nat "$@"
	;;
"stop")
	stop_nat "$@"
	;;
*)
	echo "$USAGE"
	;;
esac
