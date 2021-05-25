#!/bin/sh

php-fpm -d
nginx -g 'daemon off;'
