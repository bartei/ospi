#!/bin/bash -e

echo "add shell script for mounting overlay fs with readonly partitions and squashfs management"
install -m 755 files/overlayroot.sh "${ROOTFS_DIR}/sbin/overlayroot.sh"
install -m 755 files/overlayroot.py "${ROOTFS_DIR}/sbin/overlayroot.py"
install -m 755 files/snapshot "${ROOTFS_DIR}/sbin/snapshot"

echo "Adding the egg user to the sudo group for the HMI distribution"
on_chroot <<EOF
adduser $FIRST_USER_NAME sudo
EOF