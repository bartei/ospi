#!/bin/bash -e

on_chroot <<EOF
cd /root
git clone https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python
git fetch -p
git checkout dev

poetry run pip install kivy[base]
poetry install

cp ./systemd/rotary-controller.service /etc/systemd/system/.
systemctl enable rotary-controller.service
EOF
