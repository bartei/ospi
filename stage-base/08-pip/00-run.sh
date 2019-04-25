#!/bin/bash -e

# Add pip extra-index-url for the sources we intend to use
install -m 644 files/pip.conf		"${ROOTFS_DIR}/etc/pip.conf"

# Install python pip for python3
on_chroot << EOF
cd /tmp
rm -f "/tmp/*.py"
wget https://bootstrap.pypa.io/get-pip.py
python3 get-pip.py
rm get-pip.py
EOF
