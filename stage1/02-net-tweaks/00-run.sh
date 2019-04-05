#!/bin/bash -e

install -m 644 files/ipv6.conf "${ROOTFS_DIR}/etc/modprobe.d/ipv6.conf"
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"

# Stefano Bertelli - This is the network configuration we intend to use, it replaces the defaults
install -m 644 files/interfaces "${ROOTFS_DIR}/etc/network/interfaces"

mkdir -p "${ROOTFS_DIR}/boot/interfaces.d"
install -m 644 files/eth0 "${ROOTFS_DIR}/boot/interfaces.d/"
install -m 644 files/wlan0 "${ROOTFS_DIR}/boot/interfaces.d/"

ln -sf /dev/null "${ROOTFS_DIR}/etc/systemd/network/99-default.link"
