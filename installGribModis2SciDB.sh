#!/bin/bash
#./modis2scidb --f MOD09Q1.A2000185.h10v08.005.2006292091707.hdf  --o /media/data/ghProjects/GRIBEIRO/build-linux/bin/res.sdbin --t 0 --b "0,1,2"


sudo apt-get install apt-utils
sudo apt-get install uild-essential
sudo apt-get install cmake
sudo apt-get install libgdal-dev
sudo apt-get install gdal-bin
#sudo apt-get install libboost-all-dev


mkdir gribeiro
mkdir gribeiro/build-linux
cd gribeiro
git clone https://github.com/gqueiroz/modis2scidb.git
cd build-linux

cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE:STRING="Release" -DCMAKE_CXX_FLAGS:STRING="-lpthread -std=c++0x" ../modis2scidb/build/cmake
make -j 4
sudo make install
sudo ldconfig

