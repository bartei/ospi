#!/bin/bash -e

log "Configure default audio device as the HDMI display"
install -m 644 files/asound.conf "${ROOTFS_DIR}/etc/asound.conf"
