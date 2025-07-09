#!/bin/bash -e

install -v -m 644 files/rcp.service "${ROOTFS_DIR}/etc/systemd/system/rcp.service"
install -v -m 755 files/start.sh "${ROOTFS_DIR}/start.sh"

on_chroot <<EOF
cd /
rm -rf /rotary-controller-python
git clone --depth 1 --branch "v1.2.0" https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python

virtualenv --clear venv
source ./venv/bin/activate
pip install .

systemctl enable rcp.service || true
systemctl enable NetworkManager || true
EOF
