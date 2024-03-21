#!/bin/bash -e

on_chroot <<EOF
cd /root
git clone https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python
poetry run pip install kivy[base]
poetry install
EOF

# on_chroot <<EOF
# cd /root
# cd rotary-controller-python
# bash install-service.sh
# EOF
