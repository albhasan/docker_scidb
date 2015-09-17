#!/bin/bash
export LC_ALL="en_US.UTF-8"
chmod u+s /usr/bin/sudo
dpkg --list | grep paradigm4 | awk '{print $2}' | xargs sudo dpkg --purge
dpkg --list | grep scidb | awk '{print $2}' | xargs sudo dpkg --purge

./installR.sh
Rscript /home/scidb/installPackages.R packages=scidb verbose=0 quiet=0

yes | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''

#--------------
#sudo su scidb
su scidb <<'EOF'
cd ~
export LC_ALL="en_US.UTF-8"
#echo "#***** ***** SCIDB" >> ~/.bashrc
#------------ local development ---------------------
#echo "export SCIDB_VER=15.7" >> ~/.bashrc
#echo "export SCIDB_INSTALL_PATH=/home/scidb/dev_dir/scidbtrunk/stage/install" >> ~/.bashrc
#echo "export SCIDB_BUILD_TYPE=RelWithDebInfo" >> ~/.bashrc # Debug
#echo "export PATH=/home/scidb/dev_dir/scidbtrunk/stage/install/bin:$PATH" >> ~/.bashrc
#echo "export MALLOC_CHECK_=3" >> ~/.bashrc # local development
#echo "export MALLOC_PERTURB_=127" >> ~/.bashrc # local development
#------------ cluster development -------------------
echo "export SCIDB_VER=15.7" >> ~/.bashrc
echo "export SCIDB_SOURCE_PATH=/home/scidb/dev_dir/scidbtrunk" >> ~/.bashrc
echo "export SCIDB_BUILD_PATH=/home/scidb/dev_dir/scidbtrunk/stage/build" >> ~/.bashrc
echo "export SCIDB_INSTALL_PATH=/opt/scidb/15.7" >> ~/.bashrc
echo "export SCIDB_BUILD_TYPE=RelWithDebInfo" >> ~/.bashrc
echo "export PATH=/opt/scidb/15.7/bin:$PATH" >> ~/.bashrc
#----------------------------------------------------
source ~/.bashrc

mv /home/scidb/dev_dir/scidb-15.7.0.9267 /home/scidb/dev_dir/scidbtrunk
yes | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
chmod 755 ~
chmod 755 ~/.ssh
exec ssh-agent bash
ssh-add
echo xxxx.xxxx.xxxx | /home/scidb/dev_dir/scidbtrunk/deployment/deploy.sh access root "" "" localhost
echo xxxx.xxxx.xxxx | /home/scidb/dev_dir/scidbtrunk/deployment/deploy.sh access scidb "" "" localhost

/home/scidb/dev_dir/scidbtrunk/deployment/./deploy.sh prepare_toolchain localhost
/home/scidb/dev_dir/scidbtrunk/deployment/./deploy.sh prepare_coordinator localhost
#------------ only in cluster development --------  -------------
echo xxxx.xxxx.xxxx | /home/scidb/dev_dir/scidbtrunk/deployment/deploy.sh prepare_chroot scidb localhost
#--------------------------------------------------------------
/home/scidb/dev_dir/scidbtrunk/deployment/deploy.sh prepare_postgresql postgres postgres 255.255.0.0/16 localhost
#exit
EOF
#--------------
usermod -G scidb -a postgres
chmod g+rx /home/scidb/dev_dir
sudo -u postgres ls /home/scidb/dev_dir/ # test
#--------------
#sudo su scidb
su scidb <<'EOF'
cd ~
export LC_ALL="en_US.UTF-8"
#------------ local development ---------------------
#yes | /home/scidb/dev_dir/scidbtrunk/./run.py setup
#n=`cat /proc/cpuinfo | grep "cpu cores" | uniq | awk '{print $NF}'`
#/home/scidb/dev_dir/scidbtrunk/./run.py make -j $n
#yes | /home/scidb/dev_dir/scidbtrunk/./run.py install
#------------ cluster development -------------------
yes | /home/scidb/dev_dir/scidbtrunk/./run.py setup
/home/scidb/dev_dir/scidbtrunk/deployment/./deploy.sh build_fast /tmp/packages
/home/scidb/dev_dir/scidbtrunk/deployment/./deploy.sh scidb_install /tmp/packages localhost
#----------------------------------------------------
#exit
EOF
#--------------
cp /home/scidb/scidb_docker.ini /opt/scidb/15.7/etc/config.ini
#--------------
#sudo su scidb
su scidb <<'EOF'
cd ~
export LC_ALL="en_US.UTF-8"
echo xxxx.xxxx.xxxx | /home/scidb/dev_dir/scidbtrunk/deployment/./deploy.sh scidb_prepare scidb "" scidb xxxx.xxxx.xxxx scidb_docker /home/scidb/data 2 default 1 localhost
scidb.py startall scidb_docker
#------------ local development ---------------------
#------------ cluster development -------------------
#echo xxxx.xxxx.xxxx | /home/scidb/dev_dir/scidbtrunk/deployment/./deploy.sh scidb_start scidb scidb_docker localhost
#----------------------------------------------------
iquery -naq "store(build(<num:double>[x=0:4,1,0, y=0:6,1,0], random()),TEST_ARRAY)"
iquery -aq "list('arrays')"
iquery -aq "scan(TEST_ARRAY)"
scidb.py stopall scidb_docker
#exit
EOF
#--------------
