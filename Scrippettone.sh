#!/bin/bash
mkdir -p build/KERNEL
mkdir -p build/modules

cd build

#Set enviroment
KERNEL_SRC=$PWD/linux/
TOOLS_SRC=$PWD/tools/
CCPREFIX=$PWD/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
MODULES_TEMP=$PWD/modules/
KERNEL_PATH=$PWD/KERNEL/

###Clone source###
while true; do
	read -p "Clonare il kernel da https://github.com/raspberrypi/linux.git [s/n]?" -n 1 -r -s
	case $REPLY in
		[YySs]* ) LINUX_GIT=https://github.com/raspberrypi/linux.git; break;;
		[Nn]* ) echo "";read -p "Aggiornare il kernel nella cartella ./linux [s/n]?" -n 1 -r -s UPDATE_KERNEL; break;;
		* ) echo -e "\nRispondere si o no.";;
	esac
done
echo ""
while true; do
	read -p "Clonare i tools da https://github.com/raspberrypi/tools.git [s/n]?" -n 1 -r -s
	case $REPLY in
		[YySs]* ) TOOLS_GIT=https://github.com/raspberrypi/tools.git; break;;
		[Nn]* ) echo "";read -p "Aggiornare gli strumenti nella cartella ./tools [s/n]?" -n 1 -r -s UPDATE_TOOLS; break;;
		* ) echo -e "\nRispondere si o no.";;
	esac
done

echo "Cloning...."

case $UPDATE_KERNEL in
	[YySs]* ) cd $KERNEL_SRC; git pull; cd ..;;
	* )	git clone $LINUX_GIT;;
esac

case $UPDATE_TOOLS in
	[YySs]* ) cd $TOOLS_SRC; git pull; cd ..;;
	* ) git clone $TOOLS_GIT;;
esac


#Apply ARM patch
cp ../linux-arm.patch ./linux-arm.patch
cp ../config_ip_tables ./config_ip_tables
patch -p1 -d linux/ < linux-arm.patch

#Kernel config
echo "Config..."
cd linux
make mrproper
make versatile_defconfig ARCH=arm CROSS_COMPILE=${CCPREFIX}

cat >> .config << EOF
CONFIG_CPU_V6=y
CONFIG_ARM_ERRATA_411920=y
CONFIG_ARM_ERRATA_364296=y
CONFIG_AEABI=y
CONFIG_OABI_COMPAT=y
CONFIG_PCI=y
CONFIG_SCSI=y
CONFIG_SCSI_SYM53C8XX_2=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_DEVTMPFS=y
CONFIG_DEVTMPFS_MOUNT=y
CONFIG_TMPFS=y
CONFIG_INPUT_EVDEV=y
CONFIG_EXT3_FS=y
CONFIG_EXT4_FS=y
CONFIG_VFAT_FS=y
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_ISO8859_1=y
CONFIG_FONT_8x16=y
CONFIG_LOGO=y
CONFIG_VFP=y
CONFIG_CGROUPS=y

CONFIG_MMC_BCM2835=y
CONFIG_MMC_BCM2835_DMA=y
CONFIG_DMADEVICES=y
CONFIG_DMA_BCM2708=y

CONFIG_FHANDLE=y

CONFIG_OVERLAY_FS=y

CONFIG_EXT4_FS_POSIX_ACL=y
CONFIG_EXT4_FS_SECURITY=y
CONFIG_FS_POSIX_ACL=y

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
EOF

cat ../../config_ip_tables >> .config

make menuconfig ARCH=arm CROSS_COMPILE=${CCPREFIX}

#Build kernel
echo "Building..."
make -j8 ARCH=arm CROSS_COMPILE=${CCPREFIX}
make -j8 modules_install ARCH=arm CROSS_COMPILE=${CCPREFIX} INSTALL_MOD_PATH=${MODULES_TEMP}

#Extract kernel image
echo "Extracting image..."
cd ../tools/mkimage/ 
./imagetool-uncompressed.py ${KERNEL_SRC}/arch/arm/boot/zImage
VERSION=`date +"%Y%m%d-%H%M"`
cp -r kernel.img ${KERNEL_PATH}/kernel-$VERSION.img
cd ../../
cp -r ${KERNEL_SRC}/arch/arm/boot/zImage ${KERNEL_PATH}/zImage-$VERSION

echo "The End"
