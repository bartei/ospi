# pi-gen

## Custom pi-gen: Easier Configuration and UI-Based Applications

This repository contains a custom version of **pi-gen**, which enhances the base Raspbian 
operating system with various customizations. These modifications aim to simplify the 
configuration process, particularly for networking, using ifupdown2 as the primary and
unique tool for network management.

### Customizations

The customizations provided by this version of pi-gen include:

- **ifupdown2:** Simplify network configuration
- **Plymouth Splash Logo:** Enhance the boot experience with a customized splash logo.
- **Modified Login Page:** Display system status information upon getty login.

Additionally, **avahi** is installed as part of this custom stage. Avahi facilitates device discovery on 
the network and allows for easy resource sharing when required.

### Default Configuration

By default, pi-gen is configured to create a default user, with the default password set to "default".

### Kivy Integration: High Performance UI

The most significant feature of this custom version is the inclusion of all the necessary packages 
and dependencies to install and run **Kivy** without relying on an X11 server or Wayland server. This 
configuration offers incredible performance advantages and has a minimal storage footprint. As a 
result, the Raspberry Pi becomes an ideal candidate for developing UI-based applications.

To showcase the capabilities of this custom pi-gen, two example repositories are available under my 
GitHub username:

- [Rotary Controller](https://github.com/bartei/rotary-controller-python)

Feel free to explore these repositories to learn more about developing UI applications using Kivy 
on the Raspberry Pi.

## Building the image locally

Although the images are automatically generated using GitHub actions, it might be
desirable to run and build imagess locally for development or test purposes.

If such approach is required, it is possible to reproduce the build process used
by the Github Actions by running the following command on the root folder where
the repository:

```shell
sudo ./build.sh -c kivy.conf
```

Keep in mind that the command above will run only on a Debian Bookworm operating 
system or equivalent Ubuntu version such as 20.04.

When preparing the host system for the execution of the aforementioned command,
make sure that the following packages have been installed before proceeding:

```shell
sudo apt-get update && \
sudo apt-get install -yy coreutils quilt parted qemu-user-static debootstrap zerofree zip \
dosfstools libarchive-tools libcap2-bin grep rsync xz-utils file git curl bc \
qemu-utils kpartx gpg pigz
```

The file `depends` contains a list of tools needed.  The format of this
package is `<tool>[:<debian-package>]`.

The build time will depend on the host system performance, the current build time
on github is around 35 minutes.

The provided example command leverages the current preset build configuration
used to generate the ospi base image with rotary-controller-python preinstalled.

The `kivy.conf` file contains a set of default values, changes to such default
values will allow further high level customization of the resulting image.

A description of the currently available configuration values and their purpose
is provided in the following paragraphs.


## Config

Upon execution, `build.sh` will source the file `config` in the current
working directory.  This bash shell fragment is intended to set needed
environment variables.

The following environment variables are supported:

 * `IMG_NAME` **required** (Default: unset)

   The name of the image to build with the current stage directories.  Setting
   `IMG_NAME=Raspbian` is logical for an unmodified RPi-Distro/pi-gen build,
   but you should use something else for a customized version.  Export files
   in stages may add suffixes to `IMG_NAME`.

* `USE_QCOW2` **EXPERIMENTAL** (Default: `0` )

    Instead of using traditional way of building the rootfs of every stage in
    single subdirectories and copying over the previous one to the next one,
    qcow2 based virtual disks with backing images are used in every stage.
    This speeds up the build process and reduces overall space consumption
    significantly.

    <u>Additional optional parameters regarding qcow2 build:</u>

    * `BASE_QCOW2_SIZE` (Default: 12G)

        Size of the virtual qcow2 disk.
        Note: it will not actually use that much of space at once but defines the
        maximum size of the virtual disk. If you change the build process by adding
        a lot of bigger packages or additional build stages, it can be necessary to
        increase the value because the virtual disk can run out of space like a normal
        hard drive would.

    **CAUTION:**  Although the qcow2 build mechanism will run fine inside Docker, it can happen
    that the network block device is not disconnected correctly after the Docker process has
    ended abnormally. In that case see [Disconnect an image if something went wrong](#Disconnect-an-image-if-something-went-wrong)

* `RELEASE` (Default: bullseye)

   The release version to build images against. Valid values are any supported
   Debian release. However, since different releases will have different sets of
   packages available, you'll need to either modify your stages accordingly, or
   checkout the appropriate branch. For example, if you'd like to build a
   `buster` image, you should do so from the `buster` branch.

 * `APT_PROXY` (Default: unset)

   If you require the use of an apt proxy, set it here.  This proxy setting
   will not be included in the image, making it safe to use an `apt-cacher` or
   similar package for development.

   If you have Docker installed, you can set up a local apt caching proxy to
   like speed up subsequent builds like this:

       docker-compose up -d
       echo 'APT_PROXY=http://172.17.0.1:3142' >> config

 * `BASE_DIR`  (Default: location of `build.sh`)

   **CAUTION**: Currently, changing this value will probably break build.sh

   Top-level directory for `pi-gen`.  Contains stage directories, build
   scripts, and by default both work and deployment directories.

 * `WORK_DIR`  (Default: `"$BASE_DIR/work"`)

   Directory in which `pi-gen` builds the target system.  This value can be
   changed if you have a suitably large, fast storage location for stages to
   be built and cached.  Note, `WORK_DIR` stores a complete copy of the target
   system for each build stage, amounting to tens of gigabytes in the case of
   Raspbian.

   **CAUTION**: If your working directory is on an NTFS partition you probably won't be able to build: make sure this is a proper Linux filesystem.

 * `DEPLOY_DIR`  (Default: `"$BASE_DIR/deploy"`)

   Output directory for target system images and NOOBS bundles.

 * `DEPLOY_COMPRESSION` (Default: `zip`)

   Set to:
   * `none` to deploy the actual image (`.img`).
   * `zip` to deploy a zipped image (`.zip`).
   * `gz` to deploy a gzipped image (`.img.gz`).
   * `xz` to deploy a xzipped image (`.img.xz`).


 * `DEPLOY_ZIP` (Deprecated)

   This option has been deprecated in favor of `DEPLOY_COMPRESSION`.

   If `DEPLOY_ZIP=0` is still present in your config file, the behavior is the
   same as with `DEPLOY_COMPRESSION=none`.

 * `COMPRESSION_LEVEL` (Default: `6`)

   Compression level to be used when using `zip`, `gz` or `xz` for
   `DEPLOY_COMPRESSION`. From 0 to 9 (refer to the tool man page for more
   information on this. Usually 0 is no compression but very fast, up to 9 with
   the best compression but very slow ).

 * `USE_QEMU` (Default: `"0"`)

   Setting to '1' enables the QEMU mode - creating an image that can be mounted via QEMU for an emulated
   environment. These images include "-qemu" in the image file name.

 * `LOCALE_DEFAULT` (Default: "en_GB.UTF-8" )

   Default system locale.

 * `TARGET_HOSTNAME` (Default: "raspberrypi" )

   Setting the hostname to the specified value.

 * `KEYBOARD_KEYMAP` (Default: "gb" )

   Default keyboard keymap.

   To get the current value from a running system, run `debconf-show
   keyboard-configuration` and look at the
   `keyboard-configuration/xkb-keymap` value.

 * `KEYBOARD_LAYOUT` (Default: "English (UK)" )

   Default keyboard layout.

   To get the current value from a running system, run `debconf-show
   keyboard-configuration` and look at the
   `keyboard-configuration/variant` value.

 * `TIMEZONE_DEFAULT` (Default: "Europe/London" )

   Default keyboard layout.

   To get the current value from a running system, look in
   `/etc/timezone`.

 * `FIRST_USER_NAME` (Default: `pi`)

   Username for the first user. This user only exists during the image creation process. Unless
   `DISABLE_FIRST_BOOT_USER_RENAME` is set to `1`, this user will be renamed on the first boot with
   a name chosen by the final user. This security feature is designed to prevent shipping images
   with a default username and help prevent malicious actors from taking over your devices.

 * `FIRST_USER_PASS` (Default: unset)

   Password for the first user. If unset, the account is locked.

 * `DISABLE_FIRST_BOOT_USER_RENAME` (Default: `0`)

   Disable the renaming of the first user during the first boot. This make it so `FIRST_USER_NAME`
   stays activated. `FIRST_USER_PASS` must be set for this to work. Please be aware of the implied
   security risk of defining a default username and password for your devices.

 * `WPA_ESSID`, `WPA_PASSWORD` and `WPA_COUNTRY` (Default: unset)

   If these are set, they are use to configure `wpa_supplicant.conf`, so that the Raspberry Pi can automatically connect to a wireless network on first boot. If `WPA_ESSID` is set and `WPA_PASSWORD` is unset an unprotected wireless network will be configured. If set, `WPA_PASSWORD` must be between 8 and 63 characters. `WPA_COUNTRY` is a 2-letter ISO/IEC 3166 country Code, i.e. `GB`

 * `ENABLE_SSH` (Default: `0`)

   Setting to `1` will enable ssh server for remote log in. Note that if you are using a common password such as the defaults there is a high risk of attackers taking over you Raspberry Pi.

  * `PUBKEY_SSH_FIRST_USER` (Default: unset)

   Setting this to a value will make that value the contents of the FIRST_USER_NAME's ~/.ssh/authorized_keys.  Obviously the value should
   therefore be a valid authorized_keys file.  Note that this does not
   automatically enable SSH.

  * `PUBKEY_ONLY_SSH` (Default: `0`)

   * Setting to `1` will disable password authentication for SSH and enable
   public key authentication.  Note that if SSH is not enabled this will take
   effect when SSH becomes enabled.

 * `SETFCAP` (Default: unset)

   * Setting to `1` will prevent pi-gen from dropping the "capabilities"
   feature. Generating the root filesystem with capabilities enabled and running
   it from a filesystem that does not support capabilities (like NFS) can cause
   issues. Only enable this if you understand what it is.

 * `STAGE_LIST` (Default: `stage*`)

    If set, then instead of working through the numeric stages in order, this list will be followed. For example setting to `"stage0 stage1 mystage stage2"` will run the contents of `mystage` before stage2. Note that quotes are needed around the list. An absolute or relative path can be given for stages outside the pi-gen directory.

