#!/bin/bash
file=./$1/bin/disk.img

qemu-system-i386 -monitor stdio -drive file=$file,format=raw,media=disk