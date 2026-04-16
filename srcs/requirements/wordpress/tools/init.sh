#!/bin/bash
export MYSQL_PASSWORD=$(cat ${MYSQL_PASSWORD_FILE})
export MYSQL_USER=$(cat ${MYSQL_USER_FILE})


until mysqladmin ping -h mariadb -u"${MYSQL_USER}" -p"${MYSQL_PASSWORD}" --silent; do
	sleep 2
done

cd /var/www/html
if [ ! -f wp-config.php ]; then
    wp config create --allow-root \
		--dbname=${MYSQL_DATABASE} \
		--dbuser=${MYSQL_USER} \
		--dbpass=${MYSQL_PASSWORD} \
		--dbhost=mariadb \
		--path='/var/www/html' \
		--url=https://${DOMAIN_NAME}

	wp core install	--allow-root \
				--path='/var/www/html' \
				--url=https://${DOMAIN_NAME} \
				--title=${WP_TITLE} \
				--admin_user="${WP_ADMIN}" \
				--admin_password="${WP_ADMIN_PASSWORD}" \
				--admin_email="${WP_ADMIN_EMAIL}"

	wp user create \
				"${WP_USER}" "${WP_USER_EMAIL}" \
				--role=author \
				--user_pass="${WP_USER_PASSWORD}" --allow-root

	wp cache flush --allow-root
fi
sed -i "s|listen = /run/php/php.*-fpm.sock|listen = 9001 |" /etc/php/*/fpm/pool.d/www.conf
exec php-fpm8.2 -F