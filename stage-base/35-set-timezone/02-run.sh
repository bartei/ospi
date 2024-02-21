#!/bin/bash -e

echo "Etc/UTC" > "${ROOTFS_DIR}/etc/timezone"

on_chroot << EOF
dpkg-reconfigure -f noninteractive tzdata
EOF
