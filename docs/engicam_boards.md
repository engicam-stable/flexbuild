## Build Engicam Boards
-----------------------
First of all fetch flexbuild repo and build and start the docker container:
```
$ git clone https://git.engicam.com/engicam/flexbuild.git
$ cd flexbuild
$ . setup.env
$ bld docker
$ . setup.env
```
At this point you are inside the brand new contaner.
Building engicam boards is similar to building any other board:
```
$ bld -m imx8mpicore
```
This will do the full build for a Debian desktop distro (the option -r debian:desktop)
is the default one. To build a Debian server distro:
```
$ bld -m imx8mpicore -r debian:server
```
## Deploy
---------
To deploy on SD card the distro, plug your SD card into your host machine and run:
```
$ cd build_lsdk*/images
$ flex-installer -i pf -d /dev/sdx
$ flex-installer -d /dev/sdx -m imx8mpicore -f firmware_imx8mpicore_sdboot_lpddr4.img -b boot_IMX_arm64_lts_6.6.3.tar.zst -r ../rfs/rootfs_lsdk*_debian_desktop_arm64
```
It will take some time.
To flash the distro on EMMC download the firmware, boot and rootfs files on the board
and run:
```
$ flex-installer -i pf -d /dev/mmcblk2
$ flex-installer -d /dev/mmcblk2 -m imx8mpicore -f firmware_imx8mpicore_sdboot_lpddr4.img -b boot_IMX_arm64_lts_6.6.3.tar.zst -r rootfs_lsdk*_debian_desktop_arm64.tar.zst
```
## Build single components
--------------------------
To just build the composite firmware image:
```
$ bld bsp -m imx8mpicore
```
To just build the boot partition tarball:
```
$ bld boot
```
To just build the debian desktop rootfs:
```
$ bld rfs [-r debian:desktop]
$ bld apps [-r debian_desktop]
$ bld merge-apps
$ bld packrfs
```
Debian server rootfs:
```
$ bld rfs -r debian:server
$ bld apps -r debian:server
$ bld merge-apps
$ bld packrfs
```
## Deploy single components
---------------------------
To deploy on device (SD/EMMC) a single component (e.g. composite firmware):
```
$ flex-installer -d /dev/sdx -m imx8mpicore -f firmware_imx8mpicore_sdboot_lpddr4.img
```
The previous will be overwritten. Same rule for boot parition tarball or rootfs:
```
$ flex-installer -d /dev/sdx -m imx8mpicore -b boot_IMX_arm64_lts_6.6.3.tar.zst
```
or
```
$ flex-installer -d /dev/sdx -m imx8mpicore -r rootfs_lsdk2406_debian_desktop_arm64.tar.zst
```
