# remove base user from sudo group
on_chroot <<EOF
gpasswd -d egg root
EOF
