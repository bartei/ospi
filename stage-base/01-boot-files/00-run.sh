#!/bin/bash -e

install -m 644 files/config.txt "${ROOTFS_DIR}/boot/firmware/"

sed -i "s/console=serial0,115200//" "${ROOTFS_DIR}/boot/firmware/cmdline.txt"