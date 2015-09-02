#!/bin/bash
#sudo apt-get install build-essential g++ python-dev autotools-dev gfortran libicu-dev build-essential libbz2-dev libzip-dev
mkdir installBoost
cd installBoost
wget -O boost_1_57_0.tar.gz http://sourceforge.net/projects/boost/files/boost/1.57.0/boost_1_57_0.tar.gz/download
tar xzf boost_1_57_0.tar.gz
cd boost_1_57_0/
n=`cat /proc/cpuinfo | grep "cpu cores" | uniq | awk '{print $NF}'`
./bootstrap.sh --prefix=/usr/local
#sudo ./b2  -j 4 --prefix=/usr/local install
sudo ./b2  -j $n --prefix=/usr/local install
#sudo ./b2 --with=all -j 4 cxxflags="-std=c++11" --target=shared,static install 
sudo ldconfig

