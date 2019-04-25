#!/bin/bash -e

# Install the base_kite file used to generate the modded configurations at boot
install -m 644 files/base_kite		"${ROOTFS_DIR}/etc/"