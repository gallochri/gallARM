#!/bin/sh
#Set enviroment
KERNEL_SRC=$PWD/linux/
TOOLS_SRC=$PWD/tools/
CCPREFIX=$PWD/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
mkdir modules
MODULES_TEMP=$PWD/modules/
mkdir KERNEL
KERNEL_PATH=$PWD/KERNEL/

###Clone source###
while true; do
	read -p "Clonare il kernel da https://github.com/raspberrypi/linux.git [s/n]?" -n 1 -r
	case $REPLY in
		[YySs]* ) LINUX_GIT=https://github.com/raspberrypi/linux.git; break;;
		[Nn]* ) echo "";read -p "Inserire URL git:" LINUX_GIT; break;;
		* ) echo -e "\nRispondere si o no.";;
	esac
done
echo ""
while true; do
	read -p "Clonare i tools da https://github.com/raspberrypi/tools.git [s/n]?" -n 1 -r
	case $REPLY in
		[YySs]* ) TOOLS_GIT=https://github.com/raspberrypi/tools.git; break;;
		[Nn]* ) echo "";read -p "Inserire URL git:" TOOLS_GIT; break;;
		* ) echo -e "\nRispondere si o no.";;
	esac
done

###Choose .config###
echo ""
while true; do
	echo "Scegliere il file .config:"
	echo "1- Configura manualmente"
	echo "2- config 3.10.26"
	echo "3- config 3.18.6"
	read -n 1 -r
	case $REPLY in
		[1]* ) CONFIG=1; break;;
		[2]* ) CONFIG=2; break;;
		[3]* ) CONFIG=3; break;;
		* ) echo -e "\nErrore.Scegliere una opzione";;
	esac
done

###Esecuzione####
echo "Cloning...."
git clone $LINUX_GIT
git clone $TOOLS_GIT

#Apply ARM patch
wget http://xecdesign.com/downloads/linux-qemu/linux-arm.patch
patch -p1 -d linux/ < linux-arm.patch

#Kernel config
echo "Config..."
cd linux
make mrproper
case $CONFIG in
	[1]* ) make versatile_defconfig ARCH=arm CROSS_COMPILE=${CCPREFIX}; make menuconfig ARCH=arm CROSS_COMPILE=${CCPREFIX}; break;;
	[2]* ) cp ../kernel_config/config_3.10.26 ${KERNEL_SRC}/.config; make oldconfig ARCH=arm CROSS_COMPILE=${CCPREFIX}; break;;
	[3]* ) cp ../kernel_config/config_3.18.6 ${KERNEL_SRC}/.config; make oldconfig ARCH=arm CROSS_COMPILE=${CCPREFIX}; break;;
esac

#Build kernel
echo "Building..."
make ARCH=arm CROSS_COMPILE=${CCPREFIX}
make modules_install ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MODULES_TEMP}

#Extract kernel image
echo "Extracting image..."
cd ../tools/mkimage/ 
./imagetool-uncompressed.py ${KERNEL_SRC}/arch/arm/boot/zImage
cp -r ${KERNEL_SRC}/arch/arm/boot/zImage ${KERNEL_PATH}
cp -r kernel.img ${KERNEL_PATH}

echo "The End"