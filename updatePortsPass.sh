#!/bin/bash
##############################################################
#REPLACE DEFAULT PORTS AND PASSWORDS
##############################################################
find ./* -exec sed -i 's/xxxx.xxxx.xxxx/yyyy.yyyy.yyyy/g' {} \;
find ./* -exec sed -i 's/scidb_docker/scidb_docker_bigdata/g' {} \;
find ./* -exec sed -i 's/49901/49951/g' {} \;
find ./* -exec sed -i 's/49902/49952/g' {} \;
find ./* -exec sed -i 's/49903/49953/g' {} \;
find ./* -exec sed -i 's/49904/49954/g' {} \;
find ./* -exec sed -i 's/49910/49960/g' {} \;
find ./* -exec sed -i 's/scidb1/scidb_modis1/g' {} \;
find ./* -exec sed -i 's/scidb_img/scidb_modis_img/g' {} \;
