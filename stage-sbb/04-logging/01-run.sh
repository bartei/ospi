# copy rsyslog configuration file for client-web
install -m 600 files/rsyslog.conf "${ROOTFS_DIR}/etc/rsyslog.d/00-client-web.conf"

# copy log rotate configuration file
install -m 644 files/logrotate "${ROOTFS_DIR}/etc/logrotate.d/client-web"

# execute logrotate hourly 
on_chroot << EOF
mv /etc/cron.daily/logrotate /etc/cron.hourly
EOF
