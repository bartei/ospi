#!/bin/sh
export KCFG_KIVY_KEYBOARD_MODE="systemanddock"
export KCFG_KIVY_LOG_DIR="/var/log"

python /rotary-controller-python/rcp/main.py
