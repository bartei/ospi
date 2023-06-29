#!/bin/bash

# Resizing docker partition
if [ -e /boot/skip_disk_extension ]; then
  logger "Skipping disk extension: file /boot/skip_disk_extension exists"
else
  parted /dev/mmcblk0 ---pretend-input-tty unit % resizepart 2 Yes 100%
  resize2fs /dev/mmcblk0p2
  touch /boot/skip_disk_extension
  logger "Resizing latest partition"
fi
