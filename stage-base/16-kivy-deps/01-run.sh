#!/bin/bash -e

on_chroot <<EOF
curl https://raw.githubusercontent.com/kivy/kivy/master/tools/build_linux_dependencies.sh -o build_kivy_deps.sh
chmod +x build_kivy_deps.sh
./build_kivy_deps.sh
export KIVY_DEPS_ROOT=$(pwd)/kivy-dependencies
python -m pip install "kivy[base]" kivy_examples --no-binary kivy
EOF



# # Install SDL2:
# on_chroot <<EOF
# wget https://libsdl.org/release/SDL2-2.0.10.tar.gz
# tar -zxvf SDL2-2.0.10.tar.gz
# pushd SDL2-2.0.10
# ./configure --enable-video-kmsdrm --disable-video-opengl --disable-video-x11 --disable-video-rpi
# make -j$(nproc)
# make install
# popd
# EOF
#
#
# # Install SDL2_image:
# on_chroot <<EOF
# wget https://libsdl.org/projects/SDL_image/release/SDL2_image-2.0.5.tar.gz
# tar -zxvf SDL2_image-2.0.5.tar.gz
# pushd SDL2_image-2.0.5
# ./configure
# make -j$(nproc)
# make install
# popd
# EOF
#
# # Install SDL2_mixer:
# on_chroot <<EOF
# wget https://libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.0.4.tar.gz
# tar -zxvf SDL2_mixer-2.0.4.tar.gz
# pushd SDL2_mixer-2.0.4
# ./configure
# make -j$(nproc)
# make install
# popd
# EOF
#
# # Install SDL2_ttf:
# on_chroot <<EOF
# wget https://libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.tar.gz
# tar -zxvf SDL2_ttf-2.0.15.tar.gz
# pushd SDL2_ttf-2.0.15
# ./configure
# make -j$(nproc)
# make install
# popd
# EOF
#
# # Make sure the dynamic libraries cache is updated:
# on_chroot <<EOF
# ldconfig -v
# adduser "$USER" render
# EOF
