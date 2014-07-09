#!/bin/bash
docker stop scidb1
docker ps -a  | grep -v "Up"  | grep -v "STATUS" | awk '{ print $1 }' | xargs docker rm
docker images  | grep -v "TAG"  | grep "<none>" | awk '{print $3}' | xargs docker rmi
docker build --rm=true --tag="scidb_img" .

#docker run -d -P --name="scidb1" -p 49901:49901 -p 49903:49903 -p 49904:49904 --expose=49902 --expose=49910 -v /var/bliss/scidb/test:/home/scidb/data scidb_img 
#docker run -d -P --name="scidb1" -p 49901:49901 -p 49903:49903 -p 49904:49904 --expose=49902 --expose=49910 -v /var/bliss/scidb/test:/home/scidb/data -v /var/bliss/modis:/home/scidb/modis scidb_img 
#docker run -d -P --name="scidb1" -p 49901:49901 -p 49903:49903 -p 49904:49904 --expose=49902 --expose=49910 -v /var/bliss/scidb/test/data:/home/scidb/data -v /var/bliss/scidb/test/catalog:/etc/postgresql/8.4/main -v /var/bliss/modis:/home/scidb/modis scidb_img 

#ssh -p 49901 root@localhost

