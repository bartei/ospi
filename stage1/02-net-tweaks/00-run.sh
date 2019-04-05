#!/bin/bash -e

install -m 644 files/ipv6.conf "${ROOTFS_DIR}/etc/modprobe.d/ipv6.conf"
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"
install -m 644 files/interfaces "${ROOTFS_DIR}/etc/network/interfaces"

install -m 644 files/interfaces "${ROOTFS_DIR}/etc/network/interfaces"

ln -sf /dev/null "${ROOTFS_DIR}/etc/systemd/network/99-default.link"
