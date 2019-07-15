#!/bin/bash -e

install -m 644 files/.xinitrc "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.xinitrc"
install -m 644 files/xinit.sh "${ROOTFS_DIR}/etc/profile.d/xinit.sh"

# Change the owner of .xinitrc to allow changes performed by the egg user on the startup of the system
# Eg. when you want your home page to load a different address from the stock one
on_chroot <<EOF
chown ${FIRST_USER_NAME}:${FIRST_USER_NAME} /home/${FIRST_USER_NAME}/.xinitrc
EOF

