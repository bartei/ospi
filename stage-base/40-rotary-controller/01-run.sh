#!/bin/bash -e

on_chroot <<EOF
cd /root
git clone https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python
git checkout "v1.0.16"
python3 -m venv ./venv
source ./venv/bin/activate
pip install .
cp systemd/rotary-controller.service /etc/systemd/system
systemctl daemon-reload || true
systemctl enable rotary-controller.service || true
EOF