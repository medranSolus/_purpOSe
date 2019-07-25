#!/bin/bash
for file in ./$1/bin/bootloader*; do
  qemu-system-i386 -monitor stdio $file
done
