#!/bin/bash
modprobe i2c-dev
# Calibrate the clock (default: 0x47). See datasheet for MCP7940N
i2cset -y 1 0x6f 0x08 0x47
modprobe i2c:mcp7941x
echo mcp7941x 0x6f > /sys/class/i2c-dev/i2c-1/device/new_device
hwclock -s
