#!/bin/bash -e

# Overwrite configuration file to fix avahi-daemin configurations
install -m 644 files/avahi-daemon.conf "${ROOTFS_DIR}/etc/avahi/avahi-daemon.conf"
