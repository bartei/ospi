#!/bin/bash -e

# Download the pip installer from the web
cd "${ROOTFS_DIR}/tmp/"
wget https://bootstrap.pypa.io/get-pip.py

# Install python pip for python3
on_chroot << EOF
cd /tmp
python3 get-pip.py
EOF
