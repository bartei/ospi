#!/bin/bash -e

install -m 644 files/docker.list "${ROOTFS_DIR}/etc/apt/sources.list.d/docker.list"
install -m 644 files/docker-ce "${ROOTFS_DIR}/etc/apt/preferences.d/docker-ce"

# Install the new fstab since we are using a separate partition for the docker containers
log "Overwriting the original fstab with the one contemplating the var/lib/docker mount point for p4"
install -m 644 files/fstab "${ROOTFS_DIR}/etc/fstab"

on_chroot << EOF
wget https://download.docker.com/linux/raspbian/gpg
apt-key add gpg
apt-get update
apt-get install -y --no-install-recommends docker-ce
apt-get install -y libssl-dev python3-dev
pip install -U docker-compose==1.23.2
EOF
