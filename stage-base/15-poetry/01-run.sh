#!/bin/bash -e

# finally enable services 
on_chroot <<EOF
export POETRY_NO_INTERACTION=1
export POETRY_VIRTUALENVS_CREATE=false
export POETRY_CACHE_DIR='/var/cache/pypoetry'
export POETRY_HOME='/usr/local'
export POETRY_VERSION=1.8.2

curl -sSL https://install.python-poetry.org | python3 -
EOF