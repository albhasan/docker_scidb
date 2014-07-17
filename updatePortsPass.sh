#!/bin/bash
##############################################################
#REPLACE DEFAULT PORTS AND PASSWORDS
##############################################################

# Docker image name
find ./* -exec sed -i 's/scidb_img/scidb_modis_img/g' {} \;
# Container name
find ./* -exec sed -i 's/scidb1/scidb_modis1/g' {} \;
# Container's passwords for root, postgres & scidb users
find ./* -exec sed -i 's/xxxx.xxxx.xxxx/yyyy.yyyy.yyyy/g' {} \;
# Container's SciDB configuration - see config.ini
find ./* -exec sed -i 's/scidb_docker/scidb_docker_bigdata/g' {} \;
# Container's SSH port
find ./* -exec sed -i 's/49901/49951/g' {} \;
# Container's passwords for root, postgres & scidb users
# Container's POSTGRESQL port
find ./* -exec sed -i 's/49902/49952/g' {} \;
# Container's SHIM secured port - see conf
find ./* -exec sed -i 's/49904/49954/g' {} \;
# Container's SCIDB port
find ./* -exec sed -i 's/49910/49960/g' {} \;
