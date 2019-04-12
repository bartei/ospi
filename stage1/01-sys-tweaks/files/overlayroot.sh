#!/bin/sh
#  Read-only Root-FS for Raspian using overlayfs
#  Version 2.0
#
#  Copyright (c) 2019 Stefano Bertelli
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in all
#  copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
#  SOFTWARE.
#
#  Tested with Comfile PI, Raspberry PI 3 B+
#
#  This script will mount the root filesystem read-only and overlay it with a temporary tempfs
#  which is read-write mounted. This is done using the overlayFS which is part of the linux kernel
#  since version 3.18.
#  when this script is in use, all changes made to anywhere in the root filesystem mount will be lost
#  upon reboot of the system. The SD card will only be accessed as read-only drive, which significantly
#  helps to prolong its life and prevent filesystem coruption in environments where the system is usually
#  not shut down properly
#
#  Install:
#  copy this script to /sbin/overlayRoot.sh and add "init=/sbin/overlayRoot.sh" to the cmdline.txt
#  file in the raspbian image's boot partition.
#  I strongly recommend to disable swapping before using this. it will work with swap but that just does
#  not make sens as the swap file will be stored in the tempfs which again resides in the ram.
#  run these commands on the booted raspberry pi BEFORE you set the init=/sbin/overlayRoot.sh boot option:
#  sudo dphys-swapfile swapoff
#  sudo dphys-swapfile uninstall
#  sudo update-rc.d dphys-swapfile remove
#
#  To install software, run upgrades and do other changes to the raspberry setup, simply remove the init=
#  entry from the cmdline.txt file and reboot, make the changes, add the init= entry and reboot once more.

fail(){
        echo -e "$1"
        /bin/bash
}

# load module
modprobe overlay
if [ $? -ne 0 ]; then
    fail "ERROR: missing overlay kernel module"
fi

modprobe btrfs
if [ $? -ne 0 ]; then
    fail "ERROR: missing btrfs kernel module"
fi

# mount /proc
mount -t proc proc /proc
if [ $? -ne 0 ]; then
    fail "ERROR: could not mount proc"
fi

# create a writable fs to then create our mountpoints
mount -t tmpfs inittemp /mnt
if [ $? -ne 0 ]; then
    fail "ERROR: could not create a temporary filesystem to mount the base filesystems for overlayfs"
fi

mkdir -p /mnt/lower
mkdir -p /mnt/rw
mount -t ext4 -o defaults,noatime /dev/mmcblk0p3 /mnt/rw

if [ $? -ne 0 ]; then
    fail "ERROR: could not create tempfs for upper filesystem"
fi

mkdir -p /mnt/rw/upper
mkdir -p /mnt/rw/work
mkdir -p /mnt/newroot

# mount root filesystem readonly
rootDev=`awk '$2 == "/" {print $1}' /etc/fstab`
rootMountOpt=`awk '$2 == "/" {print $4}' /etc/fstab`
rootFsType=`awk '$2 == "/" {print $3}' /etc/fstab`

mount -t ${rootFsType} -o ${rootMountOpt},ro ${rootDev} /mnt/lower

if [ $? -ne 0 ]; then
    fail "ERROR: could not ro-mount original root partition"
fi

mount -t overlay -o lowerdir=/mnt/lower,upperdir=/mnt/rw/upper,workdir=/mnt/rw/work overlayfs-root /mnt/newroot

if [ $? -ne 0 ]; then
    fail "ERROR: could not mount overlayFS"
fi

# create mountpoints inside the new root filesystem-overlay
mkdir -p /mnt/newroot/ro
mkdir -p /mnt/newroot/rw

# remove root mount from fstab (this is already a non-permanent modification)
grep -v "$rootDev" /mnt/lower/etc/fstab > /mnt/newroot/etc/fstab
echo "#the original root mount has been removed by overlayRoot.sh" >> /mnt/newroot/etc/fstab
echo "#this is only a temporary modification, the original fstab" >> /mnt/newroot/etc/fstab
echo "#stored on the disk can be found in /ro/etc/fstab" >> /mnt/newroot/etc/fstab

# change to the new overlay root
cd /mnt/newroot
pivot_root . mnt
exec chroot . sh -c "$(cat <<END
# move ro and rw mounts to the new root
mount --move /mnt/mnt/lower/ /ro
if [ $? -ne 0 ]; then
    echo "ERROR: could not move ro-root into newroot"
    /bin/bash
fi
mount --move /mnt/mnt/rw /rw
if [ $? -ne 0 ]; then
    echo "ERROR: could not move tempfs rw mount into newroot"
    /bin/bash
fi

# unmount unneeded mounts so we can unmout the old readonly root
umount /mnt/mnt
umount /mnt/proc
umount /mnt/dev
umount /mnt

# continue with regular init
exec /sbin/init
END
)"

