#!/bin/bash -e

install -m 644 files/codesyscontrol_arm_raspberry_V3.5.13.20.deb "${ROOTFS_DIR}/root/codesyscontrol_arm_raspberry_V3.5.13.20.deb"

on_chroot <<EOF
dpkg -i "/root/codesyscontrol_arm_raspberry_V3.5.13.20.deb"
systemctl enable codesyscontrol
EOF