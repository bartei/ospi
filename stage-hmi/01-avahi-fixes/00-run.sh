#!/bin/bash -e

# Add http service descriptor for avahi
install -m 644 files/http.service "${ROOTFS_DIR}/etc/avahi/services/http.service"
