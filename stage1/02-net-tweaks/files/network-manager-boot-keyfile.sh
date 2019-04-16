#!/bin/sh

# Install network configuration files for NetworkManager
for CONFIG_FILE in `ls /boot/keyfiles`
do
# converts files from dos format to unix 
dos2unix "/boot/keyfiles/${CONFIG_FILE}"
install -m 600 "/boot/keyfiles/${CONFIG_FILE}" "/etc/NetworkManager/system-connections/${CONFIG_FILE}"
done