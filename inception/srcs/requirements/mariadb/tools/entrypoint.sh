#!/bin/bash
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
    if [ ! -r /run/secrets/db_user_pass ] || \
       [ ! -r /run/secrets/db_root_pass ]; then
        echo "Missing required secrets. Please check your Docker secrets configuration."
        exit 1
    fi

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mariadbd --user=mysql & 
    pid="$!"

    while ! mariadb-admin ping --silent; do
        sleep 1
    done

    DB_USER_PASS="$(cat /run/secrets/db_user_pass)"
    DB_ROOT_PASS="$(cat /run/secrets/db_root_pass)"

    if [ -z "$DB_USER_PASS" ] || [ -z "$DB_ROOT_PASS" ]; then
        echo "Error: DB_USER_PASS or DB_ROOT_PASS is not set."
        exit 1
    fi

    export DB_ROOT_PASS
    export DB_USER_PASS

    envsubst < /tmp/init.sql | mariadb -u root

    kill -TERM "$pid"
    wait "$pid"
fi

exec "$@"
