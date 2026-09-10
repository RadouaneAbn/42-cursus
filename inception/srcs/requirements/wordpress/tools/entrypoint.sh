#!/bin/bash
set -e

if [ ! -f /var/www/wordpress/wp-config.php ]; then
    DB_USER_PASS=$(cat /run/secrets/db_user_pass)
    WP_USER_PASS=$(cat /run/secrets/wp_user_pass)
    WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_pass)

    echo "DB_NAME: $DB_NAME"
    echo "DB_USER: $DB_USER"
    echo "DB_USER_PASS: $DB_USER_PASS"
    echo "DB_PORT: $DB_PORT"

    echo "DOMAIN_NAME: $DOMAIN_NAME"
    echo "WP_ADMIN_USER: $WP_ADMIN_USER"
    echo "WP_ADMIN_EMAIL: $WP_ADMIN_EMAIL"
    echo "WP_ADMIN_PASS: $WP_ADMIN_PASS"

    echo "WP_USER: $WP_USER"
    echo "WP_USER_EMAIL: $WP_USER_EMAIL"
    echo "WP_USER_PASS: $WP_USER_PASS"


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

chown -R www-data:www-data /var/www/wordpress
chmod -R 775 /var/www/wordpress

exec "$@"