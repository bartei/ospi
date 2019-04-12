#!/bin/bash -e

install -d                          "${ROOTFS_DIR}/etc/systemd/system/rc-local.service.d"
install -m 644 files/ttyoutput.conf "${ROOTFS_DIR}/etc/systemd/system/rc-local.service.d/"
install -m 644 files/50raspi        "${ROOTFS_DIR}/etc/apt/apt.conf.d/"
install -m 644 files/console-setup  "${ROOTFS_DIR}/etc/default/"
install -m 755 files/rc.local       "${ROOTFS_DIR}/etc/"

on_chroot << EOF
systemctl disable hwclock.sh
systemctl disable nfs-common
systemctl disable rpcbind
if [ "${ENABLE_SSH}" == "1" ]; then
	systemctl enable ssh
else
	systemctl disable ssh
fi
systemctl enable regenerate_ssh_host_keys
EOF

on_chroot <<EOF
for GRP in input spi i2c gpio; do
	groupadd -f -r "\$GRP"
done
for GRP in adm dialout cdrom audio users video games plugdev input gpio spi i2c netdev; do
  adduser $FIRST_USER_NAME \$GRP
done
EOF

on_chroot << EOF
setupcon --force --save-only -v
EOF

on_chroot << EOF
usermod --pass='*' root
EOF

rm -f "${ROOTFS_DIR}/etc/ssh/"ssh_host_*_key*
