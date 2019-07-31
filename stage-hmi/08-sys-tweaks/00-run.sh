#!/bin/bash -e


# remove stock auto resize 
rm -rf "${ROOTFS_DIR}/etc/init.d/resize2fs_once"

# add shell script for mounting overlay fs with readonly partitions and squashfs management
install -m 755 files/overlayroot.sh "${ROOTFS_DIR}/sbin/overlayroot.sh"
install -m 755 files/overlayroot.py "${ROOTFS_DIR}/sbin/overlayroot.py"
