#Located in the ~ directory

###
#	If the connection isn't working, check out `route -n` to display
#	the currently put-in-place routes, as the router (gateway) for
#	the network to be connected may not be routing to the desired
#	destination.
#
#	If you need to add the route, use this IP for an example...
#
#	`sudo route add default gw 10.0.0.1 wlp3s0`
#
#	This will add a default route to the gateway of 10.0.0.1 of the
#	network adapter wlp3s0. This will automatically send data to
#	there to be sent and recieved where need be.
#
###

#Will notify you if there is already a route set as default to this gateway
sudo route add default gw 10.0.0.1 wlp3s0

#Reset ethernet adapter by shutting it down and deleting the ip that was added
ip link set eno1 down
ip addr del 192.168.150.1/24 dev eno1

#Set IP to network with the IP that belongs to the router for the network
ip addr add 192.168.150.1/24 dev eno1
ip link set eno1 up

#Enable packet forwarding over IPv4
sysctl net.ipv4.ip_forward=1

#Make iptables forward packets from ethernet to Wi-Fi
iptables -t nat -A POSTROUTING -o wlp3s0 -s 192.168.150.0/24 -j MASQUERADE

#Reset all daemons with new config files
sudo systemctl daemon-reload

#Reset DHCP IPv4 server to allow for newest rules to take effect
sudo systemctl restart dhcpd4.service

#Reset DNS service now that eno1 is enabled
sudo systemctl restart dnsmasq.service

#iptables -t nat -A POSTROUTING -o wlp3s0 -j MASQUERADE
#iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -i eno1 -o wlp3s0 -j ACCEPT
#iptables -A FORWARD -i wlp3s0 -o eno1 -j ACCEPT
iptables --policy FORWARD ACCEPT

