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
	echo "1- scelta A"
	echo "2- scelta B"
	echo "3- scelta C"
	read -n 1 -r
	case $REPLY in
		[1]* ) echo "A"; break;;
		[2]* ) echo "B"; break;;
		[3]* ) echo "C"; break;;
		* ) echo -e "\nErrore.Scegliere una opzione";;
	esac
done

exit 

###Esecuzione####
git clone $LINUX_GIT
git clone $TOOLS_GIT

#Apply ARM patch
wget http://xecdesign.com/downloads/linux-qemu/linux-arm.patch
patch -p1 -d linux/ < linux-arm.patch

#Clean kernel config
cd linux
make mrproper



echo ""
echo "$LINUX_GIT"
echo "$TOOLS_GIT"