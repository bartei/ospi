#!/bin/bash -e

echo "Etc/UTC" > "${ROOTFS_DIR}/etc/timezone"
# rm "${ROOTFS_DIR}/etc/localtime"

on_chroot << EOF
dpkg-reconfigure -f noninteractive tzdata
EOF
