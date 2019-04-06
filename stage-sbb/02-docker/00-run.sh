#!/bin/bash -e

install -m 644 files/docker.list "${ROOTFS_DIR}/etc/apt/sources.list.d/docker.list"
install -m 644 files/docker-ce "${ROOTFS_DIR}/etc/apt/preferences.d/docker-ce"

# Install docker and docker-compose
on_chroot << EOF
wget https://download.docker.com/linux/raspbian/gpg
apt-key add gpg
apt-get update
apt-get install -y --no-install-recommends docker-ce
apt-get install libssl-dev python3-dev
pip install -U docker-compose==1.23.2
EOF
