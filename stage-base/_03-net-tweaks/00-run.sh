#!/bin/bash -e

# removing some stock net apt packages
on_chroot <<EOF
apt-get autoremove --purge dhcpcd5
apt-get autoremove --purge firmware-atheros
apt-get autoremove --purge firmware-libertas
apt-get autoremove --purge firmware-realtek
apt-get autoremove --purge raspberrypi-net-mods
EOF

# change hostname file with dummy placeholder
install -m 644 files/hostname "${ROOTFS_DIR}/etc/hostname"

# permissions of network manager configuration files have to be 600
# boot here it does not matter since they are still in the boot folder
# these files will be then copied by network-manager-boot-keyfile.service
mkdir -p "${ROOTFS_DIR}/boot/keyfiles"
install -m 777 files/ethernet "${ROOTFS_DIR}/boot/keyfiles/ethernet"
install -m 777 files/wifi "${ROOTFS_DIR}/boot/keyfiles/wifi"

# add service to unbind/bind lan78xx driver
# https://github.com/raspberrypi/firmware/issues/1100
install -m 755 files/reload-lan.sh "${ROOTFS_DIR}/sbin/reload-lan.sh"
install -m 644 files/reload-lan.service "${ROOTFS_DIR}/etc/systemd/system/reload-lan.service"

# add service to copy network manager configuration files from boot folder to network manager folder
install -m 755 files/network-manager-boot-keyfile.sh "${ROOTFS_DIR}/sbin/network-manager-boot-keyfile.sh"
install -m 644 files/network-manager-boot-keyfile.service "${ROOTFS_DIR}/etc/systemd/system/network-manager-boot-keyfile.service"

# finally enable services 
on_chroot <<EOF
systemctl enable reload-lan.service
systemctl enable network-manager-boot-keyfile.service
EOF