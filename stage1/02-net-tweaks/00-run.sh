#!/bin/bash -e

install -m 644 files/ipv6.conf "${ROOTFS_DIR}/etc/modprobe.d/ipv6.conf"
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"

# this is the bash script to stop -> start pagekite whenever e network goes to down or goes to up 
install -m 744 files/restart-pagekite.sh "${ROOTFS_DIR}/etc/NetworkManager/dispatcher.d/restart-pagekite.sh"
# the permission of the configuration files have to be 600 otherwise network manager skips them 
install -m 600 files/ethernet "${ROOTFS_DIR}/etc/NetworkManager/system-connections/ethernet"
install -m 600 files/wifi "${ROOTFS_DIR}/etc/NetworkManager/system-connections/wifi"

ln -sf /dev/null "${ROOTFS_DIR}/etc/systemd/network/99-default.link"