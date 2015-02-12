#!/bin/bash
export LC_ALL="en_US.UTF-8"
echo "##################################################"
echo "SET UP OF SCIDB 14 ON A DOCKER CONTAINER"
echo "##################################################"



#********************************************************
echo "***** Update container-user ID to match host-user ID..."
#********************************************************
export NEW_SCIDB_UID=1004
export NEW_SCIDB_GID=1004
OLD_SCIDB_UID=$(id -u scidb)
OLD_SCIDB_GID=$(id -g scidb)
usermod -u $NEW_SCIDB_UID -U scidb
groupmod -g $NEW_SCIDB_GID scidb
find / -uid $OLD_SCIDB_UID -exec chown -h $NEW_SCIDB_UID {} +
find / -gid $OLD_SCIDB_GID -exec chgrp -h $NEW_SCIDB_GID {} +
#********************************************************
echo "***** Moving PostGres files..."
#********************************************************
/etc/init.d/postgresql stop
cp -aR /var/lib/postgresql/8.4/main /home/scidb/catalog/main
rm -rf /var/lib/postgresql/8.4/main
ln -s /home/scidb/catalog/main /var/lib/postgresql/8.4/main
/etc/init.d/postgresql start
#********************************************************
echo "***** Setting up passwordless SSH..."
#********************************************************
yes | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sshpass -f /home/scidb/pass.txt ssh-copy-id "root@localhost -p 49901"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "root@0.0.0.0 -p 49901"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "root@127.0.0.1 -p 49901"
su scidb <<'EOF'
cd ~
yes | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sshpass -f /home/scidb/pass.txt ssh-copy-id "scidb@localhost -p 49901"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "scidb@0.0.0.0 -p 49901"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "scidb@127.0.0.1 -p 49901"
EOF
#********************************************************
echo "***** Installing SciDB..."
#********************************************************
cd ~
wget https://github.com/Paradigm4/deployment/archive/14.8.tar.gz
tar xzf 14.8.tar.gz
cd /root/deployment-14.8/cluster_install
yes | ./cluster_install -s /home/scidb/scidb_docker.ini
#********************************************************
echo "***** Installing SHIM..."
#********************************************************
cd ~
wget http://paradigm4.github.io/shim/shim_14.8_amd64.deb
yes | gdebi -q shim_14.8_amd64.deb
rm /var/lib/shim/conf
mv /home/root/conf /var/lib/shim/conf
rm shim_14.8_amd64.deb
/etc/init.d/shimsvc stop
/etc/init.d/shimsvc start
#----------------
#sudo su scidb
su scidb <<'EOF'
cd ~
#****************************************************************************************
sed -i 's/1239/49904/g' ~/.bashrc
#****************************************************************************************
source ~/.bashrc
#********************************************************
echo "***** ***** Starting SciDB..."
#********************************************************
yes | scidb.py initall scidb_docker
/home/scidb/./startScidb.sh
#********************************************************
echo "***** ***** Testing installation using IQuery..."
#********************************************************
iquery -naq "store(build(<num:double>[x=0:4,1,0, y=0:6,1,0], random()),TEST_ARRAY)"
iquery -aq "list('arrays')"
iquery -aq "scan(TEST_ARRAY)"
rm /home/scidb/pass.txt
EOF
#----------------
#********************************************************
echo "***** SciDB setup finished sucessfully!"
#********************************************************
