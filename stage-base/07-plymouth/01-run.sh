#!/bin/bash -e

# Install the modified cmdline.txt which disables the raspberry logos and uses the splash in quiet mode
install -m 644 files/cmdline.txt "${ROOTFS_DIR}/boot/cmdline.txt"

# Create the theme directory
mkdir -p /usr/share/plymouth/themes/faccos

# Install the theme files into the new directory
install -m 644 files/facco-splash.png "${ROOTFS_DIR}/usr/share/plymouth/themes/facco-splash.png"
install -m 644 files/faccos.plymouth "${ROOTFS_DIR}/usr/share/plymouth/themes/faccos.plymouth"
install -m 644 files/faccos.script "${ROOTFS_DIR}/usr/share/plymouth/themes/faccos.script"

# Now configure plymouthd to use the newly created boot theme
install -m 644 files/plymouthd.conf "${ROOTFS_DIR}/etc/plymouth/plymouthd.conf"
