#!/bin/bash -e

install -m 644 files/docker.list "${ROOTFS_DIR}/etc/apt/sources.list.d/docker.list"

# Install the new fstab since we are using a separate partition for the docker containers
log "Overwriting the original fstab with the one contemplating the var/lib/docker mount point for p4"

install -m 644 files/fstab "${ROOTFS_DIR}/etc/fstab"
# Install python pip for python3
on_chroot << EOF
wget https://download.docker.com/linux/raspbian/gpg
apt-key add gpg
apt-get update
apt-get install -y --no-install-recommends docker-ce=18.06.0~ce~3-0~raspbian libssl-dev python3-dev
pip install -U docker-compose==1.23.2
EOF
