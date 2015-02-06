#!/bin/sh
#Set enviroment
KERNEL_SRC=$PWD/linux/
CCPREFIX=$PWD/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
mkdir modules
MODULES_TEMP=$PWD/modules/

#Clone Source 
git clone https://github.com/raspberrypi/linux.git
git clone https://github.com/raspberrypi/tools.git

#Apply ARM patch
wget http://xecdesign.com/downloads/linux-qemu/linux-arm.patch
patch -p1 -d linux/ < linux-arm.patch

exit
