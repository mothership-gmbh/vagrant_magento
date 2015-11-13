#!/bin/bash
docker rm $(docker ps -a -q)
docker run -d --name=mariadb -p 127.0.0.1:3306:3306 -v /opt/mariadb/data:/data -e USER="super" -e PASS="super123" paintedfox/mariadb
docker run -d -p 9200:9200 -p 9300:9300 -v /home/docker/elasticsearch:/data elasticsearch:1.7.3 /usr/share/elasticsearch/bin/elasticsearch -Des.config=/data/elasticsearch.yml -Des.config=/data/elasticsearch.yml
