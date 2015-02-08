#!/bin/sh
#Set enviroment
KERNEL_SRC=$PWD/linux/
CCPREFIX=$PWD/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
MODULES_TEMP=$PWD/modules/
mkdir KERNEL
KERNEL_PATH=$PWD/KERNEL/

#Extract kernel image
cd tools/mkimage/ 
./imagetool-uncompressed.py ${KERNEL_SRC}/arch/arm/boot/zImage
cp -r ${KERNEL_SRC}/arch/arm/boot/zImage ${KERNEL_PATH}
cp -r kernel.img ${KERNEL_PATH}