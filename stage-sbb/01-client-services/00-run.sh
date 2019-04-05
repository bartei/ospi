#!/bin/bash -e

# Install python pip for python3
on_chroot << EOF
pip install -U client-services-master
EOF

