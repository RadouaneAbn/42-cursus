#!/bin/bash
set -e

chown -R www-data:www-data /var/www/wordpress
chmod -R 775 /var/www/wordpress

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    if [ ! -r /run/secrets/db_user_pass ] || \
       [ ! -r /run/secrets/wp_user_pass ] || \
       [ ! -r /run/secrets/wp_admin_pass ]; then
        echo "Missing required secrets. Please check your Docker secrets configuration."
        exit 1
    fi

    DB_USER_PASS=$(cat /run/secrets/db_user_pass)
    WP_USER_PASS=$(cat /run/secrets/wp_user_pass)
    WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_pass)

    wp core download --allow-root --path=/var/www/wordpress

    wp config create \
        --allow-root \
        --dbname="${DB_NAME}" \
        --dbuser="${DB_USER}" \
        --dbpass="${DB_USER_PASS}" \
        --dbhost="mariadb:${DB_PORT}" \
        --path=/var/www/wordpress

    wp core install \
        --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path=/var/www/wordpress

    wp user create \
        --allow-root \
        "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASS}" \
        --role=author \
        --path=/var/www/wordpress
fi

exec "$@"