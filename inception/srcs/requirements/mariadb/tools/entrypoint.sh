#!/bin/bash
set -e

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mariadbd --user=mysql & 
    pid="$!"

    while ! mariadb-admin ping --silent; do
        sleep 1
    done

    DB_USER_PASS="$(cat /run/secrets/db_user_pass)"
    DB_ROOT_PASS="$(cat /run/secrets/db_root_pass)"

    export DB_ROOT_PASS
    export DB_USER_PASS

    envsubst < /tmp/init.sql > /tmp/init_new.sql

    envsubst < /tmp/init.sql | mariadb -u root

    kill -TERM "$pid"
    wait "$pid"
fi

exec "$@"
