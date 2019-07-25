#!/bin/bash
GCC=gcc-9.1.0
if ! [ -x "$(command -v git)" ]; then
    echo "Git must be installed!" >&2
    exit 1
fi
if ! [ -x "$(command -v qemu-system-i386)" ]; then
    echo "Qemu must be installed!" >&2
    exit 1
fi
if ! [ -x "$(command -v nasm)" ]; then
    echo "Nasm must be installed!" >&2
    exit 1
fi
if ! [ -x "$(command -v bison)" ]; then
    echo "Bison must be installed!" >&2
    exit 1
fi
if ! [ -x "$(command -v flex)" ]; then
    echo "Flex must be installed!" >&2
    exit 1
fi
dpkg -s "libgmp3-dev" >/dev/null 2>&1 ||
{
    echo "libgmp3-dev must be installed!";
    exit 1
}
dpkg -s "libmpc-dev" >/dev/null 2>&1 ||
{
    echo "libmpc-dev must be installed!";
    exit 1
}
dpkg -s "libmpfr-dev" >/dev/null 2>&1 ||
{
    echo "libmpfr-dev must be installed!";
    exit 1
}
dpkg -s "texinfo" >/dev/null 2>&1 ||
{
    echo "Texinfo must be installed!";
    exit 1
}
dpkg -s "libcloog-isl-dev" >/dev/null 2>&1 ||
{
    echo "libcloog-isl-dev must be installed!";
    exit 1
}
dpkg -s "libisl-dev" >/dev/null 2>&1 ||
{
    echo "libisl-dev must be installed!";
    exit 1
}
wget ftp://ftp.fu-berlin.de/unix/languages/gcc/releases/$GCC/$GCC.tar.gz
tar xvzf ./$GCC.tar.gz -C ./tools/src
rm -f $GCC.tar.gz
mkdir ./tools/src
cd ./tools/src
git clone git://sourceware.org/git/binutils-gdb.git
cd ../..
export PREFIX="$PWD/Tools"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"
cd ./tools/src
mkdir build-binutils
mkdir build-gcc
cd build-binutils
../binutils-gdb/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
which -- $TARGET-as || echo $TARGET-as is not in the PATH
cd ../build-gcc
../$GCC/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
cd ../..
rm -rf ./tools/src
