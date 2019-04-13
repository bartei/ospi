#!/bin/bash -e

install -m 644 files/client-services-cron "${ROOTFS_DIR}/etc/cron.d/"

# Install python pip for python3
on_chroot << EOF
pip install -U client-services-master
EOF

