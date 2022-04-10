#!/bin/bash

echo "NETWORK STARTUP"
#Located in the ~ directory
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
#NetCtl Profile
NT_P=$6

#Disable both interfaces
sudo ip link set $TX_IF down
sudo ip link set $RX_IF down

#Stop netctl NT profile
sudo netctl stop $NT_P

#Re-enable just the wireless interface - Ethernet will start on it's own in the forwarding script
#sudo ip link set $TX_IF up

#Start wireless connection
sudo netctl start $NT_P

#Start the forwarding script
sudo ./forwarding.sh $TX_IF $RX_IF $TX_GATEWAY $RX_NET $RX_RUT



###
#
#	It's safe to assume that if the location of the file isn't specified at the top of the file, then it should be located in /etc
#
###
