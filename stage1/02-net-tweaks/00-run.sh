#!/bin/bash -e

install -m 644 files/ipv6.conf "${ROOTFS_DIR}/etc/modprobe.d/ipv6.conf"
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"

# add patch to unbind/bind lan78xx driver
# https://github.com/raspberrypi/firmware/issues/1100
install -m 755 files/reload-lan.sh "${ROOTFS_DIR}/sbin/reload-lan.sh"
# add service to run sh script above 
install -m 644 files/reload-lan.service "${ROOTFS_DIR}/etc/systemd/system/reload-lan.service"

# this is the bash script to stop -> start pagekite whenever e network goes to down or goes to up 
install -m 744 files/restart-pagekite.sh "${ROOTFS_DIR}/etc/NetworkManager/dispatcher.d/restart-pagekite.sh"

# the permission of the configuration files have to be 600 otherwise network manager skips them 
install -m 600 files/ethernet "${ROOTFS_DIR}/etc/NetworkManager/system-connections/ethernet"
install -m 600 files/wifi "${ROOTFS_DIR}/etc/NetworkManager/system-connections/wifi"

ln -sf /dev/null "${ROOTFS_DIR}/etc/systemd/network/99-default.link"

on_chroot <<EOF
systemctl enable reload-lan.service
EOF