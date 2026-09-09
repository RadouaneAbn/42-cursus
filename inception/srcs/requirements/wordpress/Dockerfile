FROM debian:trixie-backports

RUN apt-get update && \
    apt-get install -y \
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
        php8.4-zip && \
    rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.4/fpm/pool.d/www.conf
RUN envsubst < /etc/php/8.4/fpm/pool.d/www.conf > /etc/php/8.4/fpm/pool.d/www.conf
    
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp


EXPOSE 9000

CMD ["php-fpm8.4", "-F"]