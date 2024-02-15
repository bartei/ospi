#!/bin/bash -e

# finally enable services 
on_chroot <<EOF
pip install poetry --break-system-packages
EOF