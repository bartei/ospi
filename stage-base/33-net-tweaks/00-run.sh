#!/bin/bash -e

# removing some stock net apt packages
on_chroot <<EOF
apt-get autoremove --purge -yy dhcpcd5
EOF

# change hosts file
install -m 644 files/hosts "${ROOTFS_DIR}/etc/hosts"

# change hostname file with dummy placeholder
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"
