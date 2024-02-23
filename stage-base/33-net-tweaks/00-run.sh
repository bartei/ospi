#!/bin/bash -e

# change hosts file
install -m 644 files/hosts "${ROOTFS_DIR}/etc/hosts"

# change hostname file with dummy placeholder
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"
