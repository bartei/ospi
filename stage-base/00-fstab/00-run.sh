#!/bin/bash -e

# Install the new fstab
log "Overwriting the original fstab"
install -m 644 files/fstab "${ROOTFS_DIR}/etc/fstab"