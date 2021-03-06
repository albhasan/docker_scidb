#!/bin/bash
docker stop scidb14
docker rm scidb14
docker rmi scidb14_img
docker build --rm=true --tag="scidb14_img" .

docker run -d --name="scidb14" -p 49901:22 -p 49902:8083 --expose=5432 --expose=1239 scidb_img

#docker run -d --name="scidb14" -p 49901:22 -p 49902:8083 --expose=5432 --expose=1239 -v /var/bliss/scidb/test/data:/home/scidb/data scidb_img
#docker run -d --name="scidb14" -p 49901:22 -p 49902:8083 --expose=5432 --expose=1239 -v /var/bliss/scidb/test/data:/home/scidb/data -v /var/bliss/scidb/test/catalog:/home/scidb/catalog scidb_img 
#docker run -d --name="scidb14" -p 49901:22 -p 49902:8083 --expose=5432 --expose=1239 -v /var/bliss/scidb/test/data:/home/scidb/data -v /var/bliss/scidb/test/catalog:/home/scidb/catalog -v /var/bliss/modis:/home/scidb/modis scidb_img 

#ssh -p 49901 root@localhost
