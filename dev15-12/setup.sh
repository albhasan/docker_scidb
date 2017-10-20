#!/bin/bash
docker stop scidb_dev15
docker rm scidb_dev15
docker rmi scidb_dev15_img
docker build --rm=true --tag="scidb_dev15_img" .

docker run --privileged -d --name="scidb_dev15" -p 49910:22  --expose=22 --expose=1239 --expose=5432 scidb_dev15_img

#ssh -p 49901 root@localhost
