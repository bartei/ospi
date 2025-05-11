#!/bin/bash -e

install -v -m 644 files/rcp.service "${ROOTFS_DIR}/etc/systemd/system/rcp.service"
install -v -m 755 files/start.sh "${ROOTFS_DIR}/start.sh"

on_chroot <<EOF
git clone --depth 1 --branch "v1.0.32" https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python
pip install .
systemctl enable rcp.service || true
systemctl enable NetworkManager || true
EOF
