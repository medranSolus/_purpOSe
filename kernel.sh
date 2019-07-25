#!/bin/bash
for file in ./$1/bin/kernel*; do
    if [ $1 = "x86" ] || [ $1 = "x86_64" ]; then
        if grub-file --is-x86-multiboot $file; then
	    if [ $1 = "x86" ]; then
            	qemu-system-i386 -kernel $file
	    else
		qemu-system-x86_64 -kernel $file
	    fi
    	else
      	    echo Error: Kernel is not in multiboot specification!
        fi
    else
        echo Not implemented yet
    fi
done

