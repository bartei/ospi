#!/bin/bash -e

on_chroot <<EOF
cd /root
git clone --depth 1 --branch v1.0.12 https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python
git fetch -p
git checkout
python3 -m venv ./venv
source ./venv/bin/activate
pip install .
cp systemd/rotary-controller.service /etc/systemd/system
systemctl daemon-reload || true
systemctl enable rotary-controller.service || true
EOF