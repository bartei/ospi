#!/bin/bash -e

install -m 644 files/.xinitrc "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.xinitrc"
install -m 644 files/xinit.sh "${ROOTFS_DIR}/etc/profile.d/xinit.sh"

chown ${FIRST_USER_NAME}:${FIRST_USER_NAME} "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.xinitrc"
