#!/bin/bash -e

rm -rf "${ROOTFS_DIR}/etc/init.d/resize2fs_once"
install -m 755 files/rc.local "${ROOTFS_DIR}/etc/rc.local"
install -m 755 files/overlayroot.sh "${ROOTFS_DIR}/sbin/overlayroot.sh"

on_chroot <<EOF
apt-get autoremove --purge dphys-swapfile
EOF