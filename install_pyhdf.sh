#!/bin/bash
##############################################################
#INSTALL PYHDF
#Adapted from https://gist.github.com/1408088.git
##############################################################
sudo apt-get update
sudo apt-get install python-numpy python-scipy python-matplotlib ipython ipython-notebook python-pandas python-sympy python-nose libhdf4-dev swig
mkdir ~/install_pyhdf
cd ~/install_pyhdf
wget -c http://ufpr.dl.sourceforge.net/project/pysclint/pyhdf/0.8.3/pyhdf-0.8.3.tar.gz
tar zxvf pyhdf-0.8.3.tar.gz
cd pyhdf-0.8.3
#sudo apt-get install libhdf4-dev
#sudo apt-get install python2.6-dev
cd pyhdf
#sudo apt-get install swig
swig -python hdfext.i
cd ..
export INCLUDE_DIRS=/usr/include/hdf
export LIBRARY_DIRS=/usr/lib
export NOSZIP=1
python setup.py install
rm -rf ~/install_pyhdf

