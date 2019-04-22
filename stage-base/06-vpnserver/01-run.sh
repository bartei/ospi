#!/bin/bash -e

# Make sure the /opt folder exists
mkdir -p /opt

# Install Vpnserver Code
install -m 644 files/vpnserver/vpnserver.tar.gz "${ROOTFS_DIR}/opt/"

# Decompress the folder for the vpnserver software
tar -xzvf "${ROOTFS_DIR}/opt/vpnserver.tar.gz"

# Make sure correct permissions are set for the vpn server executables
chmod 755 "${ROOTFS_DIR}/opt/vpnserver/vpncmd"
chmod 755 "${ROOTFS_DIR}/opt/vpnserver/vpnserver"

# Install Vpnserver Systemd Service
install -m 644 files/vpnserver/softether-vpn.service "${ROOTFS_DIR}/etc/systemd/system"

# Enable the vpnserver systemd service in the chroot system
on_chroot << EOF
systemctl enable softether-vpn
EOF
