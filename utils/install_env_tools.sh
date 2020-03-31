#!/bin/bash
GCC=gcc-9.3.0
_errors=0
_arch=cross
_gcc_git=ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/$GCC/$GCC.tar.gz
_binutils_git=git://sourceware.org/git/binutils-gdb.git

function main()
{
    check_for_needed_apps
    if ((_errors > 0)); then
        if ((_errors == 1)); then
            echo "1 package has been found missing. Download it first."
        else
            echo "$_errors packages has been found missing. Download them first."
        fi
        exit $_errors
    fi

    mkdir tools_src
    wget $_gcc_git
    tar xvzf $GCC.tar.gz -C ./tools_src
    rm -f $GCC.tar.gz
    cd tools_src
    git clone $_binutils_git
    cd ..

    ########## x86 ##########
    _arch=x86
    export TARGET=i386-elf
    install_arch
    ########## end ##########
    rm -rf ./tools_src

    mkdir cross/inc/kernel
    mkdir cross/inc/libk
    mkdir cross/src/kernel
    mkdir cross/src/libk
}

#################### FUNCTIONS ####################

# Needs to specify _arch variable and export TARGET machine
function install_arch()
{
    mkdir $_arch/bin
    make_dirs
    mkdir $_arch/tools
    export PREFIX="$PWD/$_arch/tools"
    export PATH="$PREFIX/bin:$PATH"
    cd ./tools_src
    mkdir build-binutils
    mkdir build-gcc
    cd build-binutils
    ../binutils-gdb/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
    proc=$(nproc)
    ((proc++))
    make -j$proc
    make install
    which -- $TARGET-as || echo $TARGET-as is not in the PATH
    cd ../build-gcc
    ../$GCC/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
    make all-gcc
    make all-target-libgcc
    make install-gcc
    make install-target-libgcc
    cd ..
    rm -rf ./build-gcc ./build-binutils
    cd ..

    mkdir $_arch/inc/libc
    mkdir $_arch/inc/libk
    mkdir $_arch/src/libc
    mkdir $_arch/src/libk
}

# Needs to specify _arch variable
function make_dirs()
{
    mkdir $_arch/obj
    mkdir $_arch/obj/bootloader
    mkdir $_arch/obj/acpica
    mkdir $_arch/obj/kernel
    mkdir $_arch/obj/libc
    mkdir $_arch/obj/libk
}

# Shows missing packages and return number of missing in _errors variable
function check_for_needed_apps()
{
    if ! [ -x "$(command -v git)" ]; then
        echo "Git must be installed!" >&2
        ((_errors++))
    fi
    if ! [ -x "$(command -v sudo)" ]; then
        echo "Sudo must be installed!" >&2
        ((_errors++))
    fi
    if ! [ -x "$(command -v gcc)" ]; then
        echo "Gcc must be installed!" >&2
        ((_errors++))
    fi
    if ! [ -x "$(command -v qemu-system-i386)" ]; then
        echo "Qemu must be installed!" >&2
        ((_errors++))
    fi
    if ! [ -x "$(command -v nasm)" ]; then
        echo "Nasm must be installed!" >&2
        ((_errors++))
    fi
    if ! [ -x "$(command -v bison)" ]; then
        echo "Bison must be installed!" >&2
        ((_errors++))
    fi
    if ! [ -x "$(command -v flex)" ]; then
        echo "Flex must be installed!" >&2
        ((_errors++))
    fi
    pacman -Q gmp >/dev/null 2>&1 ||
    dpkg -s "libgmp3-dev" >/dev/null 2>&1 ||
    {
        echo "GMP must be installed!";
        ((_errors++))
    }
    pacman -Q libmpc >/dev/null 2>&1 ||
    dpkg -s "libmpc-dev" >/dev/null 2>&1 ||
    {
        echo "MPC must be installed!";
        ((_errors++))
    }
    pacman -Q mpfr >/dev/null 2>&1 ||
    dpkg -s "libmpfr-dev" >/dev/null 2>&1 ||
    {
        echo "MPFR must be installed!";
        ((_errors++))
    }
    pacman -Q texinfo >/dev/null 2>&1 ||
    dpkg -s "texinfo" >/dev/null 2>&1 ||
    {
        echo "Texinfo must be installed!";
        ((_errors++))
    }
    pacman -Q yay >/dev/null 2>&1 &&
    yay -Q cloog >/dev/null 2>&1 ||
    dpkg -s "libcloog-isl-dev" >/dev/null 2>&1 ||
    {
        echo "CLooG must be installed!";
        ((_errors++))
    }
}

# Script start
main