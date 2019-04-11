#!/bin/sh

interface=$1 status=$2
if [ "$status" = "up" ] || [ "$status" = "down" ]; then
  su -c 'systemctl stop pagekite'
  su -c 'systemctl start pagekite'
fi
