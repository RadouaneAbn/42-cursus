#!/bin/bash

# if a command fails exit
set -e

DB_USER_PASS="$(cat /run/secrets/db_user_pass)"
DB_ROOT_PASS="$(cat /run/secrets/db_root_pass)"

echo "user pass: $DB_USER_PASS"
echo "root pass: $DB_ROOT_PASS"
echo "db name: $DB_NAME"

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then

    echo "running mariadb-install-db"

    mariadb-install-db --user=mysql --data-dir=/var/lib/mysql > /dev/null

    echo "mariadb-install-db done2"

    mariadbd --user=mysql &
    pid="$!"

    echo "mariadbd started: $pid"

    while ! mariadb-admin ping --silent; do
        sleep 1
    done

    echo "mariadbd is up"

    mariadb -u root<< EOF
ALTER user 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    echo "all done!"

    kill -TERM "$pid"
    wait "$pid"
fi

exec "$@"
