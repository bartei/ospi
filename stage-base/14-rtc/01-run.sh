#!/bin/bash -e

log "Adding RTC service file"
install -m 644 files/config-rtc-MCP79410.service "${ROOTFS_DIR}/etc/systemd/system/config-rtc-MCP79410.service"

log "Adding RTC shell script"
install -m 755 files/configrtc.sh "${ROOTFS_DIR}/sbin/configrtc.sh"

# finally enable services 
on_chroot <<EOF
systemctl enable config-rtc-MCP79410.service
EOF