#!/bin/bash -e

# clear screen after boot from a getty 
install -m 644 files/autologin.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"
perl -pi -e "s/PLACEHOLDER_BASE_USER/${$FIRST_USER_NAME}/g" "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"

on_chroot <<EOF
ln -fs /lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
EOF