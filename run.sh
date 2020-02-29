#!/bin/bash
file=./$1/bin/disk.img

qemu-system-i386 -monitor stdio $file