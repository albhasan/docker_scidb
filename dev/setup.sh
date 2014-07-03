#!/bin/bash
docker stop scidb_dev1
docker ps -a | grep -v "Up" | grep -v "STATUS" | awk '{ print $1 }' | xargs docker rm
docker images | grep -v "TAG" | grep "<none>" | awk '{print $3}' | xargs docker rmi
docker build --rm=true --tag="scidb_dev_img" .
docker run -d -P --name="scidb_dev1" -p 49901:22  --expose=1239 --expose=5432 scidb_dev_img
ssh -p 49901 root@localhost
