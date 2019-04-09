#!/bin/bash -e

install -m 644 files/ipv6.conf "${ROOTFS_DIR}/etc/modprobe.d/ipv6.conf"
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"

install -m 644 files/ethernet "${ROOTFS_DIR}/etc/NetworkManager/system-connections/ethernet"
install -m 644 files/wifi "${ROOTFS_DIR}/etc/NetworkManager/system-connections/wifi"
install -m 744 files/restart-pagekite.sh "${ROOTFS_DIR}/etc/NetworkManager/dispatcher.d/restart-pagekite.sh"

ln -sf /dev/null "${ROOTFS_DIR}/etc/systemd/network/99-default.link"