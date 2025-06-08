#!/bin/sh
export KCFG_KIVY_KEYBOARD_MODE="systemanddock"
export KCFG_KIVY_LOG_DIR="/var/log"

. /rotary-controller-python/venv/bin/activate
python /rotary-controller-python/rcp/main.py
