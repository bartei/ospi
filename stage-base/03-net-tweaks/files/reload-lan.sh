#!/bin/sh -e
#
# reload-lan.sh
# Stefano Bertelli 2019
#
# By default this script does nothing.

echo "Unbinding Driver"
echo -n "1-1.1.1:1.0" > /sys/bus/usb/drivers/lan78xx/unbind

sleep 1
echo "Binding Driver"
echo -n "1-1.1.1:1.0" > /sys/bus/usb/drivers/lan78xx/bind

exit 0
