#!/bin/bash -e

on_chroot << EOF
export VERSION=18.06.0-ce && curl -sSL get.docker.com | sh
EOF
