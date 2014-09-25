#!/bin/bash
chmod u+s /usr/bin/sudo
dpkg --list | grep scidb | awk '{print $2}' | xargs sudo dpkg --purge
#--------------
#sudo su scidb
su scidb <<'EOF'
cd ~
export LC_ALL="en_US.UTF-8"
export SCIDB_VER=14.8
export SCIDB_INSTALL_PATH=/home/scidb/dev_dir/scidbtrunk/stage/install
export PATH=$SCIDB_INSTALL_PATH/bin:$PATH
yes | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
echo xxxx.xxxx.xxxx | /home/scidb/dev_dir/scidbtrunk/deployment/deploy.sh access root "" "" localhost
echo xxxx.xxxx.xxxx | /home/scidb/dev_dir/scidbtrunk/deployment/deploy.sh access scidb "" "" localhost
/home/scidb/dev_dir/scidbtrunk/deployment/./deploy.sh prepare_toolchain localhost
/home/scidb/dev_dir/scidbtrunk/deployment/deploy.sh prepare_postgresql postgres postgres 255.255.0.0/16 localhost
#exit
EOF
#--------------
usermod -G scidb -a postgres
chmod g+rx /home/scidb/dev_dir
#--------------
#sudo su scidb
su scidb <<'EOF'
cd ~
yes | /home/scidb/dev_dir/scidbtrunk/./run.py setup
/home/scidb/dev_dir/scidbtrunk/./run.py make -j4
export LC_ALL="en_US.UTF-8"
yes | /home/scidb/dev_dir/scidbtrunk/./run.py install
/home/scidb/dev_dir/scidbtrunk/./run.py start
/home/scidb/dev_dir/scidbtrunk/stage/install/bin/./iquery
set lang afl;
list('types');
exit;
/home/scidb/dev_dir/scidbtrunk/./run.py stop
#exit
EOF
#--------------

