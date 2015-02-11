#!/bin/sh
#Set enviroment
KERNEL_SRC=$PWD/linux/
TOOLS_SRC=$PWD/tools/
CCPREFIX=$PWD/tools/arm-bcm2708/arm-bcm2708-linux-gnueabi/bin/arm-bcm2708-linux-gnueabi-
MODULES_TEMP=$PWD/modules/
KERNEL_PATH=$PWD/KERNEL/

#Clean kernel config
cd linux
make mrproper

#Menuconfig
make versatile_defconfig ARCH=arm CROSS_COMPILE=${CCPREFIX}
make menuconfig ARCH=arm CROSS_COMPILE=${CCPREFIX}

#System Type --->
#	[*] Support ARM V6 processor
#	[*] ARM errata: Invalidation of the Instruction Cache operation can fail
#	[*] ARM errata: Possible cache data corruption with hit-under-miss enabled
#Floating point emulation --->
#	[*] VFP-format floating point maths
#Bus support --->
#	[*] PCI support
#Device Driver --->
#	Generic Driver Options --->
#		[*] Maintain a devtmpfs filesystem to mount at /dev
#		[*] Automount devtmpfs at /dev, after the kernel mounted the rootfs
#	SCSI Device Support --->
#		<*> SCSI device support
#		<*> SCSI CDROM support
#		[*] SCSI low-level drivers --->
#			<*> SYM53C8XX Version 2 SCSI support
#	Input device support --->
#		<*> Event interface
#File systems --->
#	<*> Ext3 journalling file system support
#	<*> The Extended 4 (ext4) filesystem
#	Pseudo filesystems  --->
#		 [*] Tmpfs virtual memory file system support (former shm fs)
#
# Optional #
#General Setup --->
#	<*> Kernel .config support                                                                                                    │ │  
#	[*] Enable access to .config through /proc/config.gz
#Device Driver --->
#	Graphics support --->
#		Console display driver support  --->
#			<*> Framebuffer Console support
#		[*] Bootup logo  --->
