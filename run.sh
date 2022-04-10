#!/bin/bash

#IF facing desired net
TX_IF=wlp6s0
#IF eth
RX_IF=enp5s0
#Gateway on desired net
TX_GATEWAY=10.0.0.1
#RX_NET w/ CIDR
RX_NET=192.168.150.0/24
#RX_NET Routing interface
RX_RUT=192.168.150.1/24
#NetCtl Profile
NT_P=NT_H

cd src/
sudo ./networkingStartup.sh $TX_IF $RX_IF $TX_GATEWAY $RX_NET $RX_RUT $NT_P
