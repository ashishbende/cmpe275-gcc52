#!/bin/bash
# Basic script to install gcc5.2 on ubuntu 14.04
# For CMPE 275 class 2015  
# Author: Ashish Bende
# Source: https://gist.github.com/maxlevesque/5813df2fcee107c757f4#file-howto-gcc-5-2-ubuntu15-04-sh
#
# Use it at your own risk. 
# This script doesn't run testsuites from gcc package.


[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"
if [ $EUID -ne 0 ]; then printf "\nPlease run this script as root\n"; exit 1; fi

printf "\n\n ---- Adding ubuntu latest toolchain ppa ----\n"
apt-add-repository -y ppa:ubuntu-toolchain-r/test
echo "press any key to continue ..."
read -n 1 -s

printf "\n\n ---- Installing necessary packages ---- \n"

apt-get update && apt-get -y install wget build-essential libgmp-dev libmpc-dev libisl-dev libmpfr-dev
apt-get -y dist-upgrade

printf "\n\n ---- Now lets install gcc5.2 ----\n"
printf "\n  Installation location is /usr/local/gnu/gcc-5.2/"
printf " If this script doesnt work for you, delete gnu directory from installation location"
mkdir -p /usr/local/gnu/gcc-5.2.0/

printf "\n\n Now we will download gcc5.2 source package \n"
echo "press any key to continue ..."
read -n 1 -s

wget -c http://mirror1.babylon.network/gcc/releases/gcc-5.2.0/gcc-5.2.0.tar.bz2
tar jxvf gcc-5.2.0.tar.bz2
cd gcc-5.2.0
mkdir build
cd build

printf "\n\n Now lets get ready for some serious cpu action \n"

echo "press any key to continue ..."
read -n 1 -s

# Note u can remove --disable-multilib option if you are running 64 bit system. Added this option to work on ec2

../configure --prefix=/usr/local/gnu/gcc-5.2.0/  --disable-multilib --disable-werror --with-system-zlib --enable-checking=release --enable-languages=c,c++,fortran 

printf "\n This may take a while. Go grab a coffee or take a nap :D"
#NPROC=$(nproc)
read -n 1 -s

ulimit -s 32768 && make -j 2 #$NPROC

make install
if [ $? -eq 0 ];then
    printf "\n\n Lets create link to run gcc-5.2 directly from terminal"
    printf "\n Use gcc-5.2,cpp-5.2 to run compiler"

    ln -sv /usr/local/gnu/gcc-5.2.0/bin/gcc /usr/bin/gcc-5.2
    ln -sv /usr/local/gnu/gcc-5.2.0/bin/g++ /usr/bin/g++-5.2
    ln -sv /usr/local/gnu/gcc-5.2.0/bin/cpp /usr/bin/cpp-5.2
    ln -sv /usr/local/gnu/gcc-5.2.0/bin/c++ /usr/bin/c++-5.2
    printf "\n\n All Done!"
else 
    printf " \n Sorry 'make' failed on this system \n."
    exit 1
fi
exit 0
