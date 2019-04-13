#!/bin/bash -e

# adding repo to get docker apt package
install -m 644 files/docker.list "${ROOTFS_DIR}/etc/apt/sources.list.d/docker.list"

# pinning of the docker version (newer versions of docker are slow on Raspberry PI)
install -m 644 files/docker-ce "${ROOTFS_DIR}/etc/apt/preferences.d/docker-ce"

# installing docker here. Docker can't be installed using default package file list since version needs to be pinned
on_chroot << EOF
wget https://download.docker.com/linux/raspbian/gpg
apt-key add gpg
apt-get update
apt-get install -y --no-install-recommends docker-ce
apt-get install -y libssl-dev python3-dev
pip install -U docker-compose==1.23.2
EOF

# update service docker file in order to change work directory from /var/lib/docker to /opt/docker
install -m 644 files/docker.service "${ROOTFS_DIR}/lib/systemd/system/docker.service"
