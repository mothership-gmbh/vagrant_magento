#!/bin/bash
docker rm $(docker ps -a -q)
docker run -d --name=mariadb -p 127.0.0.1:3306:3306 -v /opt/mariadb/data:/data -e USER="super" -e PASS="super123" paintedfox/mariadb
docker run -d -p 9200:9200 -p 9300:9300 -v /home/docker/elasticsearch/data:/usr/share/elasticsearch/data -v /home/docker/elasticsearch/config/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml elasticsearch:2.1 /usr/share/elasticsearch/bin/elasticsearch -Des.insecure.allow.root=true
