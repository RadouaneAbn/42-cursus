FROM debian:bookworm

ARG WORDPRESS_PORT

RUN apt update && apt install -y gettext-base

RUN apt install -y \
        wget \
        gettext-base \
        ca-certificates \
        php8.2-cli \
        php8.2-fpm \
        php8.2-mysql \
        php8.2-curl \
        php8.2-gd \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-zip \
        libfcgi-bin && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.tmp

RUN envsubst < /etc/php/8.2/fpm/pool.d/www.tmp \
    > /etc/php/8.2/fpm/pool.d/www.conf && \
    rm /etc/php/8.2/fpm/pool.d/www.tmp

COPY tools/entrypoint.sh .
RUN chmod +x /entrypoint.sh
COPY tools/healthcheck.sh .
RUN chmod +x /healthcheck.sh

RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

EXPOSE ${WORDPRESS_PORT}

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["php-fpm8.2", "-F"]