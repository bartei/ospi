#!/bin/sh

# Install network configuration files for NetworkManager
for CONFIG_FILE in `ls /boot/keyfiles`
do
install -m 600 "/boot/keyfiles/${CONFIG_FILE}" "/etc/NetworkManager/system-connections/${CONFIG_FILE}"
done