#!/bin/bash

exec php8.2 -S "0.0.0.0:${ADMINER_PORT}" -t /var/www/adminer