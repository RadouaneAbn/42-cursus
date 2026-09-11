FROM debian:13

ARG WORDPRESS_PORT

COPY tools/healthcheck.sh .
RUN chmod +x /healthcheck.sh

RUN apt update && apt install -y gettext-base

RUN apt install -y \
        wget \
        gettext-base \
        ca-certificates \
        php8.4-cli \
        php8.4-fpm \
        php8.4-mysql \
        php8.4-curl \
        php8.4-gd \
        php8.4-mbstring \
        php8.4-xml \
        php8.4-zip \
        libfcgi-bin && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.4/fpm/pool.d/www.tmp

RUN envsubst < /etc/php/8.4/fpm/pool.d/www.tmp \
    > /etc/php/8.4/fpm/pool.d/www.conf && \
    rm /etc/php/8.4/fpm/pool.d/www.tmp

COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

EXPOSE ${WORDPRESS_PORT}

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["php-fpm8.4", "-F"]