#!/bin/sh
#Set enviroment
KERNEL_SRC=$PWD/linux/
CCPREFIX=$PWD/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
MODULES_TEMP=$PWD/modules/

#Clean kernel config
cd linux
make mrproper

#uncomment the kernel chosen

#Clean kernel config with manual changes
#cp ../config_3.18.5_manual .config

#Kernel config from old qemu kernel
cp ../config_3.10.26_qemu .config
make oldconfig ARCH=arm CROSS_COMPILE=${CCPREFIX}
