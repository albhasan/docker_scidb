#!/bin/bash

# SINGLE NODE INSTALLATION OF SCIDB

################################################################################
# OUTSIDE docker
################################################################################

# build the image
docker build --tag="sdb_ubuntu14_img" .

# start container
docker run -it --dns=150.163.2.4 --dns-search=dpi.inpe.br --expose=22 --expose=1239 --expose=5432 --expose=8083 --expose=8080  -v /home/alber/shared:/home/scidb/shared sdb_ubuntu14_img bash

################################################################################
# INSIDE docker container
################################################################################

# install additional compilers
add-apt-repository ppa:ubuntu-toolchain-r/test
apt-get update && yes | apt-get install gcc-4.9 g++-4.9 cpp-4.9 gfortran-4.9 g++


# install cityhash
cd ~ && git clone https://github.com/google/cityhash.git && cd cityhash
./configure && make all check CXXFLAGS="-g -O3" && make install

#-------------------------------------------------------------------------------
# as SCIDB user
#-------------------------------------------------------------------------------
su scidb

# enable root user
sudo passwd root
# test
sudo passwd -u root # it should return: passwd: password expiry information changed

# set up SSH
sudo /usr/sbin/update-rc.d ssh defaults
sudo sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo service ssh start
sudo service ssh status # it should return: sshd is running

# prepare ssh paswordless login 
cd ~
ssh-keygen # DO NOT enter a passphrase; accept the default.
chmod 755 ~ && chmod 755 ~/.ssh && ssh-copy-id -i ~/.ssh/id_rsa.pub "scidb@127.0.0.1"
# test
ssh scidb@127.0.0.1 'ls -l /home/scidb'

#-------------------------------------------------------------------------------
# as ROOT user
#-------------------------------------------------------------------------------
sudo su
cd ~
ssh-keygen # DO NOT enter a passphrase; accept the default.
chmod 755 ~ && chmod 755 ~/.ssh && ssh-copy-id -i ~/.ssh/id_rsa.pub "root@127.0.0.1"
# test
ssh root@127.0.0.1 'ls -l /root'
exit

#-------------------------------------------------------------------------------
# as SCIDB user
#-------------------------------------------------------------------------------

# prepare SciDB source code
mkdir -p /home/scidb/dev_dir/scidbtrunk
cp /home/scidb/shared/scidb-16.9.0.db1a98f.tgz /home/scidb/dev_dir/scidbtrunk
cd /home/scidb/dev_dir/scidbtrunk
tar xzf scidb-16.9.0.db1a98f.tgz

# prepare SSH
cd /home/scidb/dev_dir/scidbtrunk
deployment/deploy.sh access root "" "" 127.0.0.1
deployment/deploy.sh access scidb "" "" 127.0.0.1
#  test
ssh 127.0.0.1 date

# remove old scidbs
# dpkg --list | grep paradigm4 | awk '{print $2}' | xargs sudo dpkg --purge
# dpkg --list | grep scidb | awk '{print $2}' | xargs sudo dpkg --purge

# install build tools
cd /home/scidb/dev_dir/scidbtrunk
sudo deployment/deploy.sh prepare_toolchain 127.0.0.1


# NO NEED FOR Preparing a Chroot (Multi-Server Only)

# install postgres
cd /home/scidb/dev_dir/scidbtrunk
deployment/deploy.sh prepare_postgresql postgres postgres 255.255.0.0/16 127.0.0.1
sudo usermod -G scidb -a postgres
chmod g+rx /home/scidb/dev_dir
sudo -u postgres ls /home/scidb/dev_dir # the 'postgres' user should have access.

# environment variables
echo "export SCIDB_VER=16.9" >> ~/.bashrc
echo "export SCIDB_INSTALL_PATH=/home/scidb/dev_dir/scidbtrunk/stage/install" >> ~/.bashrc
echo "export SCIDB_BUILD_TYPE=Debug # For performance measurement, use RelWithDebInfo" >> ~/.bashrc
echo "export PATH=$SCIDB_INSTALL_PATH/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
# test
echo $SCIDB_VER
echo $SCIDB_INSTALL_PATH
echo $PATH

# build scidb

#export BOOST_ROOT=/usr/include/boost

cd /home/scidb/dev_dir/scidbtrunk
./run.py setup # to configure build directories and cmake infrastructure
./run.py make -j4 # to build the sources.
# TODO: FAIL becaus of the wrong configuration file. Try this one /home/scidb/shared/config.ini
sudo ./run.py install 

