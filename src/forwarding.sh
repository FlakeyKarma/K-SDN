#Located in the ~ directory

echo 'FORWARDING'
#IF facing desired net
TX_IF=$1
#IF eth
RX_IF=$2
#Gateway on desired net
TX_GATEWAY=$3
#RX_NET w/ CIDR
RX_NET=$4
#RX_NET Routing interface
RX_RUT=$5

###
#	If the connection isn't working, check out `route -n` to display
#	the currently put-in-place routes, as the router (gateway) for
#	the network to be connected may not be routing to the desired
#	destination.
#
#	If you need to add the route, use this IP for an example...
#
#	`sudo route add default gw $TX_GATEWAY $TX_IF`
#
#	This will add a default route to the gateway of $TX_GATEWAY of the
#	network adapter $TX_IF. This will automatically send data to
#	there to be sent and recieved where need be.
#
###

echo ">Adding gateway $TX_GATEWAY to $TX_IF"
#Will notify you if there is already a route set as default to this gateway
sudo route add default gw ${TX_GATEWAY} ${TX_IF}

#Reset ethernet adapter by shutting it down and deleting the ip that was added
echo ">Setting $RX_IF down"
ip link set $RX_IF down
echo ">Deleting $RX_RUT on $RX_IF"
ip addr del ${RX_RUT} dev ${RX_IF}

#Set IP to network with the IP that belongs to the router for the network
echo ">Adding $RX_RUT on $RX_IF"
ip addr add ${RX_RUT} dev ${RX_IF}
echo ">Setting $RX_IF up"
ip link set ${RX_IF} up
echo ">Enable packet forwarding over IPv4"
sysctl net.ipv4.ip_forward=1

#Make iptables forward packets from ethernet to Wi-Fi
iptables -t nat -A POSTROUTING -o ${TX_IF} -s ${RX_NET} -j MASQUERADE

#Reset all daemons with new config files
sudo systemctl daemon-reload

#Reset DHCP IPv4 server to allow for newest rules to take effect
sudo systemctl restart dhcpd4.service

#Reset DNS service now that $RX_IF is enabled
sudo systemctl restart dnsmasq.service

#iptables -t nat -A POSTROUTING -o $TX_IF -j MASQUERADE
#iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -i $RX_IF -o $TX_IF -j ACCEPT
#iptables -A FORWARD -i $TX_IF -o $RX_IF -j ACCEPT
iptables --policy FORWARD ACCEPT

