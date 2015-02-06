#!/bin/sh
#Set enviroment
KERNEL_SRC=$PWD/linux/
CCPREFIX=$PWD/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
MODULES_TEMP=$PWD/modules/

#Clean kernel config
cd linux
make mrproper

#Menuconfig
cp ../config_3.18.5_manual .config
