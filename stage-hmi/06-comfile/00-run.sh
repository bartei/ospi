#!/bin/bash -e

# service to turn on backlight on 15 inches comfiles
log "Added service to turn backlight on for 15 inches comfiles"
install -m 744 files/backlight.sh "${ROOTFS_DIR}/sbin/backlight.sh"
install -m 644 files/backlight.service "${ROOTFS_DIR}/etc/systemd/system/backlight.service"

# finally enable services 
on_chroot <<EOF
systemctl enable backlight.service
EOF
