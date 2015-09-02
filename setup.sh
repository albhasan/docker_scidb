#!/bin/bash
docker stop twdtw1
docker rm twdtw1
docker rmi twdtw_img
docker build --rm=true --tag="twdtw_img" .


rm -rf /dados1/scidb/dockerCdata/twdtw1/data/*
docker run -d --dns=150.163.2.4 --name="twdtw1" -p 48901:22 -p 48902:8083 --expose=5432 --expose=1239 -v /net/chronos/dados1/modisOriginal:/home/scidb/modis -v /dados1/scidb/dockerCdata/twdtw1/data:/home/scidb/data twdtw_img



