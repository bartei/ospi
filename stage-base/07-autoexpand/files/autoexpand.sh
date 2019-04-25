#!/bin/bash

# Resizing docker partition
if [ -e /etc/diskextended ]; then
  logger "Skipping autoexpand, /etc/diskextended already exists"
else
  parted /dev/mmcblk0 ---pretend-input-tty unit % resizepart 4 Yes 100%
  resize2fs /dev/mmcblk0p4
  touch /etc/diskextended
  logger "Resizing latest partition"
fi