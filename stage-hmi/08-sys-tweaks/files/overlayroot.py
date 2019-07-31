#  Read-only Root-FS for Raspian using overlayfs
#  Version 2.1
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
import logging
import os

from hashlib import md5
from operator import itemgetter



copyright_text = """
Read-only Overlay Squash
Version 2.1

Copyright (c) 2019 Stefano Bertelli

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""


def make_folders(folders_list):
    for f in folders_list:
        log.info("Creating new folder: {}".format(f))
        try:
            os.makedirs(f, exist_ok=True)
        except Exception as err:
            log.error("Error: {}".format(err.__str__()))


def md5sum(filename):
    md5_hash = md5()
    with open(filename, "rb") as f:
        for chunk in iter(lambda: f.read(128 * md5_hash.block_size), b""):
            md5_hash.update(chunk)
    return md5_hash.hexdigest()


def sort_dict_by_key(iterable, key, reverse=False):
    return sorted(iterable, key=itemgetter(key), reverse=reverse)


def get_available_sqfs(path):
    # Produce a list of available sqfs
    available_sqfs = []
    persist_folder = path

    for item in os.listdir(persist_folder):
        full_path = os.path.join(persist_folder, item)
        base, ext = os.path.splitext(full_path)

        if ext != '.sqfs':
            continue

        # check if we have a checksum for the current file
        checksum_path = "{}.md5".format(base)
        if not os.path.exists(checksum_path):
            continue

        original_checksum = open(checksum_path).read()
        current_checksum = md5sum(full_path)

        if original_checksum != current_checksum:
            log.error("Checksum mismatch for squashfs: {}".format(full_path))
            log.error("ORIG MD5: {}".format(original_checksum))
            log.error("CURR MD5: {}".format(current_checksum))
            continue

        available_sqfs.append({
            'filename': full_path,
            'timestamp': os.path.getctime(full_path),
            'size': os.path.getsize(full_path),
            'checksum': current_checksum
        })

    return available_sqfs


if __name__ == '__main__':
    try:
        print(copyright_text)
        print("Mounting proc...")
        result = subprocess.call(['/bin/mount', '-t', 'proc', 'proc', '/proc'])
    except Exception as e:
        print("Error mount proc filesystem")
        print(e)

    try:
        print("Mounting mnt...")
        result = subprocess.call(['/bin/mount', '-t', 'tmpfs', 'inittemp', '/mnt'])
    except Exception as e:
        print("Error creating temporary filesystem for /mnt")
        print(e)

    print("Create directory trees...")
    os.makedirs("/mnt/lower")
    os.makedirs("/mnt/rw")
    os.makedirs("/mnt/persist")
    os.makedirs("/mnt/squash")

    try:
        print("Mounting mnt/rw...")
        result = subprocess.call([
            '/bin/mount',
            '-t',
            'tmpfs',
            '-o',
            'defaults,noatime,size=256M',
            'tmpfs',
            '/mnt/rw'
        ])
    except Exception as e:
        print("Error mounting the tmpfs")
        print(e)

    try:
        print("Mounting mnt/persist...")
        result = subprocess.call([
            '/bin/mount',
            '-t',
            'ext4',
            '-o',
            'defaults,noatime',
            '/dev/mmcblk0p3',
            '/mnt/persist'
        ])
    except Exception as e:
        print("Error mounting the squashfs storage filesystem")
        print(e)

    # Now that we have the persistent unit mounted we can use it to store the boot log for this function
    logging.basicConfig(filename='/mnt/persist/overlay.log', level=logging.DEBUG)
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

    # Produce a list of available sqfs
    sqfs = get_available_sqfs("/mnt/persist")
    latest_sqfs = None
    if len(sqfs) > 0:
        # Sort the list of sqfs descending by datetime
        latest_sqfs = sort_dict_by_key(sqfs, 'timestamp', reverse=True)[0]

    if latest_sqfs is not None:
        # This detail is important, we want to display it at each boot
        print("Mounting: {}".format(latest_sqfs['filename']))
        log.info("Mounting: {}".format(latest_sqfs['filename']))
        try:
            result = subprocess.call([
                '/bin/mount',
                '-t',
                'squashfs',
                latest_sqfs['filename'],
                '/mnt/squash'
            ])
        except Exception as e:
            log.error("Error: {}".format(e.__str__()))
    else:
        print("FRESH START... Don't forget to feed your birds!")
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

    print('Mounting overlay...')
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
    print('Ready for pivoting')
