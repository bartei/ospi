#!/bin/bash -e

# clear screen after boot from a getty 
# Install the modified version of rc.local which turns on the backlight on the Comfile pi 15"
install -m 644 files/rc.local "${ROOTFS_DIR}/etc/"
