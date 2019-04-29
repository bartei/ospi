#!/bin/bash -e

log "Adding necessary cmd only for splash screen"
echo -n " quiet splash logo.nologo disable_splash=1 " >> "${ROOTFS_DIR}/boot/cmdline.txt"

log "Create the theme directory"
mkdir -p "${ROOTFS_DIR}/usr/share/plymouth/themes/faccos"

log "Install the theme files into the new directory"
install -m 644 files/facco-splash.png "${ROOTFS_DIR}/usr/share/plymouth/themes/faccos/facco-splash.png"
install -m 644 files/faccos.plymouth "${ROOTFS_DIR}/usr/share/plymouth/themes/faccos/faccos.plymouth"
install -m 644 files/faccos.script "${ROOTFS_DIR}/usr/share/plymouth/themes/faccos/faccos.script"

log "Now configure plymouthd to use the newly created boot theme"
install -m 644 files/plymouthd.conf "${ROOTFS_DIR}/etc/plymouth/plymouthd.conf"
