#!/bin/bash -e

# Add docker source file to apt
install -m 644 files/docker.list "${ROOTFS_DIR}/etc/apt/sources.list.d/docker.list"

# Install service entry and script file for automatic expansion of the last partition of the disk
install -m 644 files/autoexpand.service "${ROOTFS_DIR}/etc/systemd/system/"
install -m 755 files/autoexpand.sh "${ROOTFS_DIR}/sbin/"

# Install python pip for python3
on_chroot << EOF
wget https://download.docker.com/linux/raspbian/gpg
apt-key add gpg
apt-get update
apt-get install -y --no-install-recommends docker-ce=18.06.0~ce~3-0~raspbian openssl-dev python3-dev
pip install -U docker-compose==1.23.2
EOF
