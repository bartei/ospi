#!/bin/bash -e

# Install the new fstab
log "Overwriting the original fstab"
install -m 644 files/fstab "${ROOTFS_DIR}/etc/fstab"

# Replace the placeholder with the defined username
perl -pi -e "s/PLACEHOLDER_BASE_USER/${FIRST_USER_NAME}/g" "${ROOTFS_DIR}/etc/fstab"
