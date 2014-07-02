#!/bin/bash
export LC_ALL="en_US.UTF-8"
export SCIDB_VER=14.3
export PATH=$PATH:/opt/scidb/$SCIDB_VER/bin:/opt/scidb/$SCIDB_VER/share/scidb
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/scidb/$SCIDB_VER/lib:/opt/scidb/$SCIDB_VER/3rdparty/boost/lib
/etc/init.d/shimsvc start
sudo su scidb
cd ~
yes | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sshpass -f pass.txt ssh-copy-id "scidb@localhost -p 49901"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "scidb@0.0.0.0 -p 49901"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "scidb@127.0.0.1 -p 49901"
rm /home/scidb/pass.txt
exit
/etc/init.d/postgresql restart
cd /tmp && sudo -u postgres /opt/scidb/14.3/bin/scidb.py init_syscat scidb_docker
sudo su scidb
cd ~
export SCIDB_VER=14.3
export PATH=$PATH:/opt/scidb/$SCIDB_VER/bin:/opt/scidb/$SCIDB_VER/share/scidb
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/scidb/$SCIDB_VER/lib:/opt/scidb/$SCIDB_VER/3rdparty/boost/lib
yes | scidb.py initall scidb_docker
scidb.py startall scidb_docker
scidb.py status scidb_docker
iquery -naq "store(build(<num:double>[x=0:4,1,0, y=0:6,1,0], random()),TEST_ARRAY)"
iquery -aq "list('arrays')"
iquery -aq "scan(TEST_ARRAY)"
R
install.packages('scidb', quiet = TRUE)
yes
yes
34
library(scidb)
scidbconnect("localhost", 49903)
scidblist()
iquery("scan(TEST_ARRAY)",return=TRUE)
quit()
no
exit
exit
