#!/bin/bash -e

log "Adding necessary cmd only for splash screen"
echo -n " quiet splash logo.nologo " >> "${ROOTFS_DIR}/boot/cmdline.txt"

log "Create the theme directory"
mkdir -p "${ROOTFS_DIR}/usr/share/plymouth/themes/ospi"

log "Install the theme files into the new directory"
install -m 644 files/splash.png "${ROOTFS_DIR}/usr/share/plymouth/themes/ospi/splash.png"
install -m 644 files/ospi.plymouth "${ROOTFS_DIR}/usr/share/plymouth/themes/ospi/ospi.plymouth"
install -m 644 files/ospi.script "${ROOTFS_DIR}/usr/share/plymouth/themes/ospi/ospi.script"

log "Now configure plymouthd to use the newly created boot theme"
install -m 644 files/plymouthd.conf "${ROOTFS_DIR}/etc/plymouth/plymouthd.conf"
