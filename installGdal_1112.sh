#!/bin/bash
#######################################################################
echo "INSTALL GDAL 1.11.2 WITH SCIDB SUPPORT"
#######################################################################
sudo apt-get remove libhdf4-dev
sudo apt-get install libhdf4-alt-dev

mkdir installGdal
cd installGdal

echo "Getting GDAL files..."
wget download.osgeo.org/gdal/1.11.2/gdal-1.11.2.tar.gz
tar -xzf gdal-1.11.2.tar.gz

echo "Getting SciDB files..."
git clone https://github.com/mappl/scidb4gdal
mkdir ./gdal-1.11.2/frmts/scidb
cp ./scidb4gdal/src/*.* ./gdal-1.11.2/frmts/scidb/

echo "Compiling gdal..."
cd gdal-1.11.2
./configure
make -j 4
sudo make install

echo "Finished!"
