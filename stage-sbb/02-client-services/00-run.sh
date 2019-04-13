#!/bin/bash -e

# Install python pip for python3
on_chroot << EOF
pip install -U client-services-master
EOF

# add client-services file
install -m 644 files/client-services.service "${ROOTFS_DIR}/etc/systemd/system/client-services.service"

# finally enable service
on_chroot << EOF
systemctl enable client-services
EOF
