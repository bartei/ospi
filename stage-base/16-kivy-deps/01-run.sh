#!/bin/bash -e

# Install libpng:
on_chroot <<EOF
wget https://downloads.sourceforge.net/project/libpng/libpng16/1.6.40/libpng-1.6.40.tar.gz
tar -zxvf libpng-1.6.40.tar.gz
pushd libpng-1.6.40
./configure
make -j$(nproc)
make install
popd
EOF

# Install SDL2:
on_chroot <<EOF
wget https://libsdl.org/release/SDL2-2.28.5.tar.gz
tar -zxvf SDL2-2.28.5.tar.gz
pushd SDL2-2.28.5
./configure --enable-video-kmsdrm --disable-video-opengl --disable-video-x11 --disable-video-rpi
make -j$(nproc)
make install
popd
EOF

# Install SDL2_image:
on_chroot <<EOF
wget https://libsdl.org/projects/SDL_image/release/SDL2_image-2.8.0.tar.gz
tar -zxvf SDL2_image-2.8.0.tar.gz
pushd SDL2_image-2.8.0
./configure
make -j$(nproc)
make install
popd
EOF

# Install SDL2_mixer:
on_chroot <<EOF
wget https://libsdl.org/projects/SDL_mixer/release/SDL2_mixer-2.6.3.tar.gz
tar -zxvf SDL2_mixer-2.6.3.tar.gz
pushd SDL2_mixer-2.6.3
./configure
make -j$(nproc)
make install
popd
EOF

# Install SDL2_ttf:
on_chroot <<EOF
wget https://libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.20.2.tar.gz
tar -zxvf SDL2_ttf-2.20.2.tar.gz
pushd SDL2_ttf-2.20.2
./configure
make -j$(nproc)
make install
popd
EOF


# Make sure the dynamic libraries cache is updated:
on_chroot <<EOF
ldconfig -v
adduser "$USER" render
EOF
