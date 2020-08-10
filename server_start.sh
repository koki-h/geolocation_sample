#!/bin/bash
home=$(pwd)
docker run -d -p 8080:8080 -v $home:/var/www/html centos/httpd-24-centos7
