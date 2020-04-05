#!/bin/bash
disk_file=./$1/bin/disk.img

qemu-system-i386 -monitor stdio -drive file="$disk_file",format=raw,media=disk