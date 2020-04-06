#!/bin/bash

make clean
rm -rf ./x86/tools
cd ./utils/quick_tools &&
{
    make clean
}