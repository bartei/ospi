#!/bin/bash -e

install -m 644 files/cmdline.txt "${ROOTFS_DIR}/boot/firmware/"
if ! [ -L "${ROOTFS_DIR}/boot/cmdline.txt" ]; then
	ln -s firmware/cmdline.txt "${ROOTFS_DIR}/boot/cmdline.txt"
fi

install -m 644 files/config.txt "${ROOTFS_DIR}/boot/firmware/"
if ! [ -L "${ROOTFS_DIR}/boot/config.txt" ]; then
	ln -s firmware/config.txt "${ROOTFS_DIR}/boot/config.txt"
fi
