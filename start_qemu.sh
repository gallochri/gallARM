#!/bin/bash
qemu-system-arm -kernel ./qemu-rpi-kernel/kernel-qemu \
                -cpu arm1176 \
                -m 256 \
                -M versatilepb \
                -no-reboot \
                -serial stdio \
                -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw init=/bin/bash" \
                -hda rpi.img