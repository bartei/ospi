#!/bin/bash -e

# Install the modified version of rc.local which turns on the backlight on the Comfile pi 15"
install -m 644 files/rc.local "${ROOTFS_DIR}/etc/"

# Install the modified version of the pigpiod startup script to be compatible with the CM
install -m 644 files/pigpiod.service "${ROOTFS_DIR}/lib/systemd/system/"