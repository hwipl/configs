NETNS1="dnsmasq-test1"
NETNS2="dnsmasq-test2"

VETH1="dnsmasq-veth1"
VETH2="dnsmasq-veth2"

# create network namespaces
ip netns add $NETNS1
ip netns add $NETNS2

# create veth device and move to namespaces
ip link add $VETH1 type veth peer $VETH2
ip link set $VETH1 netns $NETNS1
ip link set $VETH2 netns $NETNS2

# set veth devices up
ip netns exec $NETNS1 ip link set $VETH1 up
ip netns exec $NETNS2 ip link set $VETH2 up

# add ip address to dhcp server netns
ip netns exec $NETNS1 ip address add 192.168.1.1/24 dev $VETH1

# start dhcp server
ip netns exec $NETNS1 ./dnsmasq.sh start $VETH1 192.168.1.20,192.168.1.50 0.0.0.0/0,192.168.1.1

# start dhcp client
ip netns exec $NETNS2 dhcpcd $VETH2

# test connectivity
ip netns exec $NETNS2 ping -c 3 192.168.1.1

# stop dhcp server
ip netns exec $NETNS1 ./dnsmasq.sh stop $VETH1

# delete veth devices
ip netns exec $NETNS1 ip link delete $VETH1

# delete network namespaces
ip netns delete $NETNS1
ip netns delete $NETNS2
