#!/bin/sh
#Set enviroment
KERNEL_SRC=$PWD/linux/
TOOLS_SRC=$PWD/tools/
CCPREFIX=$PWD/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
MODULES_TEMP=$PWD/modules/
KERNEL_PATH=$PWD/KERNEL/

#Build kernel
cd linux
make ARCH=arm CROSS_COMPILE=${CCPREFIX}
make modules_install ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MODULES_TEMP}
