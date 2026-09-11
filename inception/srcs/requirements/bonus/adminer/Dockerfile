FROM debian:13

ARG ADMINER_PORT
ENV ADMINER_PORT=${ADMINER_PORT}

COPY tools/entrypoint.sh /entrypoint.sh
COPY tools/healthcheck.sh /healthcheck.sh
RUN chmod +x /entrypoint.sh
RUN chmod +x /healthcheck.sh

RUN apt-get update && \
    apt-get install -y \
        php8.4 \
        php8.4-mysqli \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/adminer

RUN curl -L https://github.com/vrana/adminer/releases/download/v6.0.2/adminer-6.0.2-en.php -o index.php

EXPOSE ${ADMINER_PORT}

ENTRYPOINT ["/entrypoint.sh"]