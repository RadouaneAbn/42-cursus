FROM debian:13

ARG DOMAIN_NAME
ARG WORDPRESS_PORT
ARG SERVER_PORT
ARG STATIC_WEBSITE_PORT
ARG PORTAINER_PORT
ARG ADMINER_PORT

RUN apt update && apt install gettext-base

RUN mkdir -p /etc/nginx/ssl

RUN apt install -y nginx openssl curl ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    openssl req -x509 \
        -nodes \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -days 365 \
        -subj "/CN=${DOMAIN_NAME}"

EXPOSE ${SERVER_PORT}

RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

COPY conf/config.conf /etc/nginx/nginx.tmp
COPY tools/healthcheck.sh /healthcheck.sh

RUN chmod +x /healthcheck.sh

RUN envsubst '${DOMAIN_NAME} ${WORDPRESS_PORT} ${SERVER_PORT} ${PORTAINER_PORT} ${STATIC_WEBSITE_PORT} ${ADMINER_PORT}' \
    < /etc/nginx/nginx.tmp > /etc/nginx/nginx.conf && \
    rm /etc/nginx/nginx.tmp

CMD [ "nginx", "-g", "daemon off;" ]