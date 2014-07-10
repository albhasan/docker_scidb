#!/bin/bash
export LC_ALL="en_US.UTF-8"
export SCIDB_VER=14.3
export PATH=$PATH:/opt/scidb/$SCIDB_VER/bin:/opt/scidb/$SCIDB_VER/share/scidb
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/scidb/$SCIDB_VER/lib:/opt/scidb/$SCIDB_VER/3rdparty/boost/lib
/etc/init.d/shimsvc start
##################################################
#UPDATE CONTAINER-USER ID TO MATCH HOST-USER ID
##################################################
#export NEW_SCIDB_UID=1005
#export NEW_SCIDB_GID=1006
#export NEW_POSTGRES_UID=109
#export NEW_POSTGRES_GID=117
#OLD_SCIDB_UID=$(id -u scidb)
#OLD_SCIDB_GID=$(id -g scidb)
#OLD_POSTGRES_UID=$(id -u postgres)
#OLD_POSTGRES_GID=$(id -g postgres)
#/etc/init.d/postgresql stop
#usermod -u $NEW_SCIDB_UID -U scidb
#groupmod -g $NEW_SCIDB_GID scidb
#find / -uid $OLD_SCIDB_UID -exec chown -h $NEW_SCIDB_UID {} +
#find / -gid $OLD_SCIDB_GID -exec chgrp -h $NEW_SCIDB_GID {} +
#usermod -u $NEW_POSTGRES_UID -U postgres
#groupmod -g $NEW_POSTGRES_GID postgres
#find / -uid $OLD_POSTGRES_UID -exec chown -h $NEW_POSTGRES_UID {} +
#find / -gid $OLD_POSTGRES_GID -exec chgrp -h $NEW_POSTGRES_GID {} +
#/etc/init.d/postgresql start
##################################################
#PASSWORDLESS SSH SETUP
##################################################
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
##################################################
#START SCIDB
##################################################
sudo su scidb
cd ~
export SCIDB_VER=14.3
export PATH=$PATH:/opt/scidb/$SCIDB_VER/bin:/opt/scidb/$SCIDB_VER/share/scidb
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/scidb/$SCIDB_VER/lib:/opt/scidb/$SCIDB_VER/3rdparty/boost/lib
/home/scidb/./startScidb.sh
sed -i 's/yes/#yes/g' /home/scidb/startScidb.sh
##################################################
#INSTALLATION TEST USING IQUERY
##################################################
iquery -naq "store(build(<num:double>[x=0:4,1,0, y=0:6,1,0], random()),TEST_ARRAY)"
iquery -aq "list('arrays')"
iquery -aq "scan(TEST_ARRAY)"
##################################################
#INSTALLATION TEST USING R
##################################################
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
##################################################
#LOG OUT
##################################################
exit
exit
