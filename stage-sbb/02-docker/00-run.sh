#!/bin/bash -e

install -m 644 files/docker.list "${ROOTFS_DIR}/etc/apt/sources.list.d/docker.list"

# Install python pip for python3
on_chroot << EOF
wget https://download.docker.com/linux/raspbian/gpg
apt-key add gpg
apt-get update
apt-get install -y --no-install-recommends docker-ce=18.06.0~ce~3-0~raspbian libssl-dev python3-dev
pip install -U docker-compose==1.23.2
EOF
