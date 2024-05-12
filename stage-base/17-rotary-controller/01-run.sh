#!/bin/bash -e

on_chroot <<EOF
cd /root
git clone https://github.com/bartei/rotary-controller-python.git
cd rotary-controller-python
git fetch -p
git checkout dev

export POETRY_NO_INTERACTION=1 \
export POETRY_VIRTUALENVS_CREATE=false \
export POETRY_CACHE_DIR='/var/cache/pypoetry' \
export POETRY_HOME='/usr/local' \
export POETRY_VERSION=1.8.2

poetry run pip install kivy[base]
poetry install
EOF
