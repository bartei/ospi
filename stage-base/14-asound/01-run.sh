#!/bin/bash -e

log "Configure default audio device as the HDMI display"
install -m 644 files/splash.png "${ROOTFS_DIR}/usr/share/plymouth/themes/ospi/splash.png"

