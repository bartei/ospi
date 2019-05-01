#!/bin/bash -e

# remove base user from sudo group
on_chroot <<EOF
deluser $FIRST_USER_NAME sudo
EOF
