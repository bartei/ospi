#!/bin/bash -e

log "Adding default public authentication key for root user"
mkdir -p "${ROOTFS_DIR}/root/.ssh"
install -m 644 files/authorized_keys "${ROOTFS_DIR}/root/.ssh/authorized_keys"
