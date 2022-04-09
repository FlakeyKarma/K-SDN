#!/bin/bash

#Located in the ~ directory
TX_IF=$1
RX_IF=$2

#Disable both interfaces
sudo ip link set wlp3s0 down
sudo ip link set eno1 down

#Stop netctl NT profile
sudo netctl stop NT

#Re-enable just the wireless interface - Ethernet will start on it's own in the forwarding script
#sudo ip link set wlp3s0 up

#Start wireless connection
sudo netctl start NT

#Start the forwarding script
sudo ./forwarding.sh $TX_IF $RX_IF



###
#
#	It's safe to assume that if the location of the file isn't specified at the top of the file, then it should be located in /etc
#
###
