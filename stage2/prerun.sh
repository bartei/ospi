#!/bin/bash -e
set -x

if [ ! -d "${ROOTFS_DIR}" ]; then
	copy_previous
fi
