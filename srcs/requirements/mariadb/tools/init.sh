#!/bin/sh

# lancer mysql en background
mysqld_safe &

# attendre démarrage
sleep 5

mysql -e "CREATE DATABASE IF NOT EXISTS testDB;"

wait

echo "salut"