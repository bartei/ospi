#!/bin/bash -e

on_chroot <<EOF
cd /root
git clone https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python
pip install . --break-system-packages
cp systemd/rotary-controller.service /etc/systemd/system
# systemctl enable rotary-controller.service
EOF
