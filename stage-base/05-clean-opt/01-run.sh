#!/bin/bash -e

# Cleaning opt folder
# Removing vc graphic libraries ~40Mb
rm -R "${ROOTFS_DIR}/opt/vc"
