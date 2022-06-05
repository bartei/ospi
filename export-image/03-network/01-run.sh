#!/bin/bash -e
set -x

install -m 644 files/resolv.conf "${ROOTFS_DIR}/etc/"
