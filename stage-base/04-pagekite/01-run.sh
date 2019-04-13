#!/bin/bash -e

# Install the base_kite file used to generate the modded configurations at boot
install -m 644 files/base_kite		"${ROOTFS_DIR}/etc/"

# Install the base_kite file used to generate the modded configurations at boot
install -m 644 files/base_hosts		"${ROOTFS_DIR}/etc/"

# Install client bootstrap service on /etc/systemd/systm
install -m 644 files/client-bootstrap.service		"${ROOTFS_DIR}/etc/systemd/system/"

# Install the bootstrap shell script into the sbin folder
install -m 755 files/bootstrap.sh		"${ROOTFS_DIR}/sbin/"

on_chroot << EOF
systemctl enable pagekite
systemctl enable client-bootstrap
EOF
