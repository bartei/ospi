#!/bin/bash -e

on_chroot <<EOF
cd /root
git clone https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv venv
uv sync
cp systemd/rotary-controller.service /etc/systemd/system
systemctl daemon-reload || true
systemctl enable rotary-controller.service || true
EOF
