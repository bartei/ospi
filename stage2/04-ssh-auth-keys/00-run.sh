#!/bin/bash -e

log "Adding default public authentication key for root user"

# add authorized key for root
mkdir -p "${ROOTFS_DIR}/root/.ssh"
install -m 644 files/authorized_keys_root "${ROOTFS_DIR}/root/.ssh/authorized_keys"

# add authorized key for base user
mkdir -p "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.ssh"
install -m 644 files/authorized_keys_base_user "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.ssh/authorized_keys"
