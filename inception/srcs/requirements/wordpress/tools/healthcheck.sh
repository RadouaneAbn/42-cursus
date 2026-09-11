#!/bin/bash

echo '<?php echo "OK"; ?>' > /tmp/health.php

if SCRIPT_FILENAME=/tmp/health.php \
   REQUEST_METHOD=GET \
   cgi-fcgi -bind -connect 127.0.0.1:${WORDPRESS_PORT} \
   | grep -q "OK"
then
    exit 0
fi

exit 1