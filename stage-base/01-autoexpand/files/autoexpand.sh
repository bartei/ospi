#!/bin/bash

# Resizing docker partition
logger "Resizing latest partition to allow for more space for docker"

parted /dev/mmcblk0 ---pretend-input-tty unit % resizepart 4 Yes 100%
resize2fs /dev/mmcblk0p4
