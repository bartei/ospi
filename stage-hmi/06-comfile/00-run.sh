#!/bin/bash -e

# Install the modified version of rc.local which turns on the backlight on the Comfile pi 15"
log "Installing new rc.local for backlight"
install -m 644 files/rc.local "${ROOTFS_DIR}/etc/"

# Install the modified version of the pigpiod startup script to be compatible with the CM
log "Modifying the current pigpiod service for the Comfile devices"
install -m 644 files/pigpiod.service "${ROOTFS_DIR}/lib/systemd/system/"

# service to turn on backlight on 15 inches comfiles
log "Added service to turn backlight on for 15 inches comfiles"
install -m 744 files/backlight.sh "${ROOTFS_DIR}/sbin/backlight.sh"
install -m 644 files/backlight.service "${ROOTFS_DIR}/etc/systemd/system/backlight.service"

# finally enable services 
on_chroot <<EOF
systemctl enable backlight.service
EOF
