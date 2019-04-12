#!/bin/bash -e

log "Adding default public authentication key for root user"
mkdir -p "${ROOTFS_DIR}/root/.ssh"
install -m 644 files/authorized_keys_root "${ROOTFS_DIR}/root/.ssh/authorized_keys"
install -m 644 files/authorized_keys_base_user "${ROOTFS_DIR}/users/${FIRST_USER_NAME}/.ssh/authorized_keys"
