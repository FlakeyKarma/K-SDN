#!/bin/bash

echo "NETWORK STARTUP"
#Located in the ~ directory
TX_IF=$1
RX_IF=$2

#Disable both interfaces
sudo ip link set $TX_IF down
sudo ip link set $RX_IF down

#Stop netctl NT profile
sudo netctl stop NT

#Re-enable just the wireless interface - Ethernet will start on it's own in the forwarding script
sudo ip link set $TX_IF up

#Start wireless connection
sudo netctl start NT

#Start the forwarding script
sudo ./forwarding.sh $TX_IF $RX_IF $3 $4 $5



###
#
#	It's safe to assume that if the location of the file isn't specified at the top of the file, then it should be located in /etc
#
###
