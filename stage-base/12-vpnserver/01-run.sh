#!/bin/bash -e

log "Install Vpnserver Code"
mkdir -p /opt
install -m 644 files/vpnserver.tar.gz "${ROOTFS_DIR}/opt/vpnserver.tar.gz"

log "Decompress the folder for the vpnserver software"
tar -xzf "${ROOTFS_DIR}/opt/vpnserver.tar.gz" --directory ${ROOTFS_DIR}/opt/

log "Removing tar archive"
rm "${ROOTFS_DIR}/opt/vpnserver.tar.gz"

log "Make sure correct permissions are set for the vpn server executables"
chmod 755 "${ROOTFS_DIR}/opt/vpnserver/vpncmd"
chmod 755 "${ROOTFS_DIR}/opt/vpnserver/vpnserver"

log "Install Vpnserver Systemd Service"
install -m 644 files/softether-vpn.service "${ROOTFS_DIR}/etc/systemd/system/softether-vpn.service"

log "Enable the vpnserver systemd service in the chroot system"
on_chroot << EOF
systemctl enable softether-vpn
EOF
