#!/bin/bash -e

# change hosts file
install -m 644 files/hosts "${ROOTFS_DIR}/etc/hosts"

# change hostname file with dummy placeholder
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"

# Always enable wifi
echo 1 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-3f300000.mmcnr:wlan"
echo 1 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-fe300000.mmcnr:wlan"
