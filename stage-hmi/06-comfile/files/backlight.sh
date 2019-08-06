#!/bin/bash

if [ ! -e /sys/class/gpio/gpio31 ]; then
  echo "31" > /sys/class/gpio/export
fi
echo "out" > /sys/class/gpio/gpio31/direction
echo "1" > /sys/class/gpio/gpio31/value