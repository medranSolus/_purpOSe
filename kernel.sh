#!/bin/bash
file=./$1/bin/Purpose/purpose.ker

if [ $1 = "x86" ]; then
    if grub-file --is-x86-multiboot $file; then
        qemu-system-i386 -monitor stdio -kernel $file
    else
        echo Error: Kernel is not in multiboot specification!
    fi
elif [ $1 = "x64" ] || [ $1 = "x86_64" ]; then
    if grub-file --is-x86-multiboot $file; then
        qemu-system-x86_64 -monitor stdio -kernel $file
    else
        echo Error: Kernel is not in multiboot specification!
    fi
else
    echo Not implemented yet
fi