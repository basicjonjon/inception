#!/bin/bash

# lancer mysql en background
mysqld_safe &

# attendre mysql
until mysqladmin ping --silent; do
    sleep 1
done

# config DB
mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

FLUSH PRIVILEGES;
EOF

# arrêter proprement
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# lancer en foreground (important Docker)
exec mysqld_safe