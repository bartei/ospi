#!/bin/bash -e

on_chroot <<EOF
cd /root
git clone https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python
export KIVY_DEPS_ROOT=/kivy-deps-build/kivy-dependencies
poetry run pip install kivy[base]
poetry install
EOF
