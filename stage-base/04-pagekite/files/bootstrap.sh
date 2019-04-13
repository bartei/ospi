#!/bin/sh
#  To install software, run upgrades and do other changes to the raspberry setup, simply remove the init=
#  entry from the cmdline.txt file and reboot, make the changes, add the init= entry and reboot once more.

# Dynamically extract mac address and write it to file
mac_address=`ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' | sed 's/://g'`

# Configure pagekite
rm /etc/pagekite.d/*
sed 's/placeholder/'${mac_address}'/g' /etc/base_kite > /etc/pagekite.d/10_default.rc

# Configure hostname
ifconfig eth0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}' | sed 's/://g' > /etc/hostname
sed 's/placeholder/'${mac_address}'/g' /etc/base_hosts > /etc/hosts
hostnamectl set-hostname ${mac_address}
