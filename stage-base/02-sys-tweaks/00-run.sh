#!/bin/bash -e

# remove unused system stock packages
on_chroot <<EOF
apt-get autoremove --purge -yy dphys-swapfile
EOF

# provide a more detailed login prompt
install -m 644 files/issue "${ROOTFS_DIR}/etc/issue"

# clear screen after boot from a getty 
install -m 644 files/getty@.service "${ROOTFS_DIR}/lib/systemd/system/getty@.service"

# give message of the current version of the OS when connecting with SSH
install -m 644 files/motd "${ROOTFS_DIR}/etc/motd"
install -m 755 files/20-issue "${ROOTFS_DIR}/etc/update-motd.d/20-issue"