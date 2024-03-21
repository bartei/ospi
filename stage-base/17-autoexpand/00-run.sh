#!/bin/bash -e

# Install service entry and script file for automatic expansion of the last partition of the disk
install -m 644 files/autoexpand.service "${ROOTFS_DIR}/etc/systemd/system/"
install -m 755 files/autoexpand.sh "${ROOTFS_DIR}/sbin/"

# Eanble autoexpand service on the system
on_chroot << EOF
systemctl enable autoexpand.service
EOF
