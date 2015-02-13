#!/bin/sh
#Set enviroment
KERNEL_SRC=$PWD/linux/
TOOLS_SRC=$PWD/tools/
CCPREFIX=$PWD/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
mkdir modules
MODULES_TEMP=$PWD/modules/
mkdir KERNEL
KERNEL_PATH=$PWD/KERNEL/

#Clone source

TOOLS_GIT=https://github.com/raspberrypi/tools.git

echo "Clonare il kernel da https://github.com/raspberrypi/linux.git [s/n] (s)?"
read LINUX_GIT
if [ "$LINUX_GIT" = "s" ]
then 
	LINUX_GIT=https://github.com/raspberrypi/linux.git
else
	echo "Inserire URL git da cui clonare il kernel:"
	read LINUX_GIT
fi
	
echo "$LINUX_GIT"