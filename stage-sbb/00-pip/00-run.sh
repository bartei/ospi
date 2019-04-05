#!/bin/bash -e

# Install the base_kite file used to generate the modded configurations at boot
install -m 644 files/base_kite		"${ROOTFS_DIR}/etc/"

# Install the base_kite file used to generate the modded configurations at boot
install -m 644 files/base_hosts		"${ROOTFS_DIR}/etc/"

# Install client bootstrap service on /etc/systemd/systm
install -m 644 files/client-bootstrap.service		"${ROOTFS_DIR}/etc/systemd/system/"

# Install the bootstrap shell script into the sbin folder
install -m 755 files/bootstrap.sh		"${ROOTFS_DIR}/sbin/"

# Download the pip installer from the web
cd "${ROOTFS_DIR}/tmp/"
wget https://bootstrap.pypa.io/get-pip.py

# Install python pip for python3
on_chroot << EOF
cd /tmp
python3 get-pip.py
EOF
