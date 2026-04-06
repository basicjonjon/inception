#!/bin/bash

if [ ! -f "/var/lib/mysql/created" ]; then
    export MYSQL_PASSWORD=$(cat ${MYSQL_PASSWORD_FILE})
    export MYSQL_ROOT_PASSWORD=$(cat ${MYSQL_ROOT_PASSWORD_FILE})
    export MYSQL_USER=$(cat ${MYSQL_USER_FILE})

    mysqld_safe &

    until mysqladmin ping --silent; do
        sleep 1
    done

    mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}'; FLUSH PRIVILEGES;" || true
    mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%'; FLUSH PRIVILEGES;"

    mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
    touch /var/lib/mysql/created
fi
exec mysqld_safe