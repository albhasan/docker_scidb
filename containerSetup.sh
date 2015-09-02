#!/bin/bash
export LC_ALL="en_US.UTF-8"
echo "##################################################"
echo "SET UP SCIDB 14 ON A DOCKER CONTAINER"
echo "##################################################"



#********************************************************
echo "***** Update container-user ID to match host-user ID..."
#********************************************************
export NEW_SCIDB_UID=6002
export NEW_SCIDB_GID=6002
OLD_SCIDB_UID=$(id -u scidb)
OLD_SCIDB_GID=$(id -g scidb)
usermod -u $NEW_SCIDB_UID -U scidb
groupmod -g $NEW_SCIDB_GID scidb
find / -uid $OLD_SCIDB_UID -exec chown -h $NEW_SCIDB_UID {} +
find / -gid $OLD_SCIDB_GID -exec chgrp -h $NEW_SCIDB_GID {} +
#********************************************************
#echo "***** ***** Creating local directories..."
#********************************************************
mkdir /home/scidb/data/catalog
mkdir /home/scidb/data/toLoad
chown scidb:scidb /home/scidb/data/catalog
chown scidb:scidb /home/scidb/data/toLoad
#********************************************************
echo "***** Moving PostGres files..."
#********************************************************
/etc/init.d/postgresql stop
cp -aR /var/lib/postgresql/8.4/main /home/scidb/data/catalog/main
rm -rf /var/lib/postgresql/8.4/main
ln -s /home/scidb/data/catalog/main /var/lib/postgresql/8.4/main
/etc/init.d/postgresql start
#********************************************************
echo "***** Setting up passwordless SSH..."
#********************************************************
yes | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sshpass -f /home/scidb/pass.txt ssh-copy-id "root@localhost"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "root@0.0.0.0"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "root@127.0.0.1"
su scidb <<'EOF'
cd ~
yes | ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
sshpass -f /home/scidb/pass.txt ssh-copy-id "scidb@localhost"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "scidb@0.0.0.0"
yes | ssh-copy-id -i ~/.ssh/id_rsa.pub  "scidb@127.0.0.1"
EOF
#********************************************************
echo "***** Installing SciDB..."
#********************************************************
cd ~
wget https://www.dropbox.com/s/vrry4eggjcs0ky8/deployment-14.12.tar
tar xf deployment-14.12.tar
cd /root/deployment/cluster_install
yes | ./cluster_install -s /home/scidb/scidb_docker.ini
#********************************************************
echo "***** Installing additional stuff..."
#********************************************************
cd ~
# TODO: Update R, maybe??????
yes | /root/./installR.sh
Rscript /home/scidb/installPackages.R packages=scidb,devtools,Rserve verbose=0 quiet=0
yes | /root/./installParallel.sh
yes | /root/./installBoost_1570.sh
yes | /root/./installGdal_1112.sh
yes | /root/./installGribModis2SciDB.sh
ldconfig
wget -P /opt/scidb/14.8/lib/scidb/plugins https://dl.dropboxusercontent.com/u/25989010/scidbResources/libr_exec.so
# Install Victor Maus's R package from source
git clone https://github.com/vwmaus/dtwSat.git
tar czf dtwSat.tar.gz ./dtwSat/*.*
R CMD INSTALL dtwSat.tar.gz
#********************************************************
echo "***** Installing SHIM..."
#********************************************************
cd ~
wget http://paradigm4.github.io/shim/ubuntu_12.04_shim_14.12_amd64.deb
yes | gdebi -q ubuntu_12.04_shim_14.12_amd64.deb
rm /var/lib/shim/conf
mv /root/conf /var/lib/shim/conf
rm ubuntu_12.04_shim_14.12_amd64.deb
/etc/init.d/shimsvc stop
/etc/init.d/shimsvc start
#----------------
#sudo su scidb
su scidb <<'EOF'
cd ~
source ~/.bashrc
#********************************************************
echo "***** ***** Starting SciDB..."
#********************************************************
/home/scidb/./startScidb.sh
sed -i -e 's/yes/#yes/g' /home/scidb/startScidb.sh
#********************************************************
echo "***** ***** Testing installation using IQuery..."
#********************************************************
iquery -naq "store(build(<num:double>[x=0:4,1,0, y=0:6,1,0], random()),TEST_ARRAY)"
iquery -aq "list('arrays')"
iquery -aq "scan(TEST_ARRAY)"
#********************************************************
#echo "***** ***** Downloading MODIS data..."
#******************************************************
#cd ~
#./downloaddata.sh
#********************************************************
echo "***** ***** Downloading required scripts..."
#********************************************************
git clone http://github.com/albhasan/modis2scidb.git
#********************************************************
echo "***** ***** Creating arrays..."
#********************************************************
iquery -af /home/scidb/createArray.afl
#********************************************************
echo "***** ***** Loading data to arrays..."
#********************************************************
python /home/scidb/modis2scidb/checkFolder.py --log DEBUG /home/scidb/data/toLoad/ /home/scidb/modis2scidb/ MOD13Q1 MOD13Q1 &
#ONLY SAO PAULO state data h13v11
#find /home/scidb/modis/MOD13Q1 -type f -name '*h13v11*.hdf' -print | parallel -j 4 --no-notice --xapply python /home/scidb/modis2scidb/hdf2sdbbin.py --log DEBUG {} /home/scidb/data/toLoad/ MOD13Q1
find /home/scidb/modis/MOD13Q1/2010 -type f -name '*h13v11*.hdf' -print | parallel -j 4 --no-notice --xapply python /home/scidb/modis2scidb/hdf2sdbbin.py --log DEBUG {} /home/scidb/data/toLoad/ MOD13Q1
find /home/scidb/modis/MOD13Q1/2011 -type f -name '*h13v11*.hdf' -print | parallel -j 4 --no-notice --xapply python /home/scidb/modis2scidb/hdf2sdbbin.py --log DEBUG {} /home/scidb/data/toLoad/ MOD13Q1
find /home/scidb/modis/MOD13Q1/2012 -type f -name '*h13v11*.hdf' -print | parallel -j 4 --no-notice --xapply python /home/scidb/modis2scidb/hdf2sdbbin.py --log DEBUG {} /home/scidb/data/toLoad/ MOD13Q1
find /home/scidb/modis/MOD13Q1/2013 -type f -name '*h13v11*.hdf' -print | parallel -j 4 --no-notice --xapply python /home/scidb/modis2scidb/hdf2sdbbin.py --log DEBUG {} /home/scidb/data/toLoad/ MOD13Q1
find /home/scidb/modis/MOD13Q1/2014 -type f -name '*h13v11*.hdf' -print | parallel -j 4 --no-notice --xapply python /home/scidb/modis2scidb/hdf2sdbbin.py --log DEBUG {} /home/scidb/data/toLoad/ MOD13Q1
#********************************************************
echo "***** ***** Waiting to finish uploading files to SciDB..."
#********************************************************
COUNTER=$(find /home/scidb/toLoad/ -type f -name '*.sdbbin' -print | wc -l)
while [  $COUNTER -gt 0 ]; do
	echo "Waiting to finish uploading files to SciDB. Files to go... $COUNTER"
	sleep 60
	let COUNTER=$(find /home/scidb/toLoad/ -type f -name '*.sdbbin' -print | wc -l)
done
#********************************************************
echo "***** ***** Removing array versions..."
#********************************************************
/home/scidb/./removeArrayVersions.sh MOD13Q1
#********************************************************
echo "***** ***** Executing TW-DTW..."
#********************************************************








rm /home/scidb/pass.txt
EOF
#----------------
#********************************************************
echo "***** SciDB setup finished sucessfully!"
#********************************************************
