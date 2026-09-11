#!/bin/bash

PASSWORD_FILE="/run/secrets/db_root_pass"

if [ ! -r "$PASSWORD_FILE" ]; then
    exit 1
fi

PASSWORD="$(cat "$PASSWORD_FILE")"

mariadb-admin ping \
    --user=root \
    --password="$PASSWORD" \
    --host=localhost \
    --silent