#!/bin/bash
docker run -d -p 8080:80 --name geolocation_php -v "$PWD":/var/www/html php:7.2-apache
