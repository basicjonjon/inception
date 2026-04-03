#!/bin/bash

mkdir -p /var/www/html
cd /var/www/html

if [ ! -f wp-config.php ]; then
    wget https://wordpress.org/latest.tar.gz
    tar -xvf latest.tar.gz --strip-components=1
    rm latest.tar.gz
    cp wp-config-sample.php wp-config.php
    sed -i "s/database_name_here/${MYSQL_DATABASE}/" wp-config.php
    sed -i "s/username_here/${MYSQL_USER}/" wp-config.php
    sed -i "s/password_here/${MYSQL_PASSWORD}/" wp-config.php
    sed -i "s/localhost/mariadb/" wp-config.php
fi
sed -i "s|listen = /run/php/php.*-fpm.sock|listen = 9000|" /etc/php/*/fpm/pool.d/www.conf
exec php-fpm8.2 -F