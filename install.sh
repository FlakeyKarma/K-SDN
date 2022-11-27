#!/bin/bash

# Install necessary packages

[ $(cat /etc/*-release | head -n1 | cut -d'"' -f2) != 'Arch' ] && echo "This project only runs for Arch linux at the moment!" && exit 1

echo "These packages are necessary to run this script."
sudo pacman -S route iptables netctl dhcp dhcpcd dnsmasq

sudo cp src/configs/* /etc
