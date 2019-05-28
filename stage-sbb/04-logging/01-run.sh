# copy rsyslog configuration file for client-web
install -m 600 files/00-client-web.conf "${ROOTFS_DIR}/etc/rsyslog.d/00-client-web.conf"

# execute logrotate hourly 
on_chroot << EOF
mv /etc/cron.daily/logrotate /etc/cron.hourly
EOF
