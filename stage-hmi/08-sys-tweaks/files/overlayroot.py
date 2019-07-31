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

import subprocess
import os

import logging


def make_folders(folders_list):
    for f in folders_list:
        log.info("Creating new folder: {}".format(f))
        try:
            os.makedirs(f, exist_ok=True)
        except Exception as err:
            log.error("Error: {}".format(err.__str__()))


if __name__ == '__main__':
    try:
        print("Mounting proc filesystem in /proc")
        result = subprocess.call(['/bin/mount', '-t', 'proc', 'proc', '/proc'])
        print("Result: {}".format(result))
    except Exception as e:
        print("Error mount proc filesystem")
        print(e)

    try:
        print("Create a writable fs to then create our mountpoints")
        result = subprocess.call(['/bin/mount', '-t', 'tmpfs', 'inittemp', '/mnt'])
        print("Result: {}".format(result))
    except Exception as e:
        print("Error creating temporary filesystem for /mnt")
        print(e)

    print("Create the required directories")
    os.makedirs("/mnt/lower")
    os.makedirs("/mnt/rw")
    os.makedirs("/mnt/persist")
    os.makedirs("/mnt/squash")

    try:
        print("Mount the tmpfs for resiliency")
        result = subprocess.call(['/bin/mount', '-t', 'tmpfs', '-o', 'defaults,noatime,size=256M', 'tmpfs', '/mnt/rw'])
        print("Result: {}".format(result))
    except Exception as e:
        print("Error mounting the tmpfs")
        print(e)

    try:
        print("Mount the squashfs storage volume: /mnt/persist")
        result = subprocess.call(['/bin/mount', '-t', 'ext4', '-o', 'defaults,noatime', '/dev/mmcblk0p3', '/mnt/persist'])
    except Exception as e:
        print("Error mounting the squashfs storage filesystem")
        print(e)

    # Now that we have the persistent unit mounted we can use it to store the boot log for this function
    logging.basicConfig(filename='/mnt/persist/overlay.log')
    log = logging.getLogger()

    log.info("Create the additional folders for the overlay mount")
    new_folders = [
        "/mnt/rw/upper",
        "/mnt/rw/work",
        "/mnt/newroot",
    ]
    make_folders(new_folders)

    # Create a list of fstab entries cleaned up and converted to lists as well
    # fstab_clean structure will be:
    # [0] -> Device
    # [1] -> Mount Point
    # [2] -> Mount Type
    # [3] -> Options
    # [4] -> Checks 0
    # [5] -> Checks 1

    fstab_raw = open('/etc/fstab').readlines()

    for item in fstab_raw:
        mount = item.split()
        if len(mount) > 2 and mount[1] == "/":
            root_dev = mount[0]
            root_mount_options = "{},ro".format(mount[3])
            root_fs_type = mount[2]
            log.info("Found root mount entry in fstab: {} -> {} [{}]".format(root_dev, root_fs_type, root_mount_options))

            log.info("Mount the root filesystem in readonly mode: /mnt/persist")
            try:
                result = subprocess.call([
                    '/bin/mount',
                    '-t', root_fs_type,
                    '-o', root_mount_options,
                    root_dev,
                    '/mnt/lower'
                ])
            except Exception as e:
                log.error("Error: {}".format(e.__str__()))

    available_squash = os.listdir("/mnt/persist")
    if 'latest.sqfs' in available_squash:
        log.info("Found an available squashfs overlay in latest.sqfs, mounting")

        try:
            result = subprocess.call([
                '/bin/mount',
                '-t',
                'squashfs',
                '/mnt/persist/latest.sqfs',
                '/mnt/squash'
            ])
        except Exception as e:
            log.error("Error: {}".format(e.__str__()))

    else:
        log.info("No squashes found in the system, mount a temporary filesystem instead")
        try:
            result = subprocess.call([
                '/bin/mount',
                '-t',
                'tmpfs',
                '-o',
                'defaults,noatime,size=1M',
                'tmpfs-squash',
                '/mnt/squash'
            ])
        except Exception as e:
            log.error("Error: {}".format(e.__str__()))

    log.info("Mounting overlay for root")
    try:
        result = subprocess.call([
            '/bin/mount',
            '-t',
            'overlay',
            '-o',
            'lowerdir=/mnt/squash:/mnt/lower,upperdir=/mnt/rw/upper,workdir=/mnt/rw/work',
            'overlayfs-root',
            '/mnt/newroot'
        ])
    except Exception as e:
        log.error("Error: {}".format(e.__str__()))

    new_folders = [
        '/mnt/newroot/ro',
        '/mnt/newroot/rw',
        '/mnt/newroot/persist',
        '/mnt/newroot/squash',
    ]
    make_folders(new_folders)
