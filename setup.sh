#!/bin/bash
docker stop scidb1
# remove stopped containers
docker ps -a  | grep -v "Up"  | grep -v "STATUS" | awk '{ print $1 }' | xargs docker rm
# remove unused images
docker images  | grep -v "TAG"  | grep "<none>" | awk '{print $3}' | xargs docker rmi
# build image
docker build --rm=true --tag="scidb_img" .
# run the container
docker run -d -P --name="scidb1" -p 49901:49901 -p 49903:49903 -p 49904:49904 --expose=49902 --expose=49910 -v /var/bliss/scidb/test:/home/scidb/data scidb_img 
# ssh the container
ssh -p 49901 root@localhost
