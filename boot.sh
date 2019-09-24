#!/bin/bash
file=./$1/bin/bootpos.bin

qemu-system-i386 -monitor stdio $file