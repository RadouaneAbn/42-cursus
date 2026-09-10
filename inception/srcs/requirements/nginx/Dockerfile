FROM debian:trixie-backports

ARG DOMAIN_NAME
ARG WORDPRESS_PORT

RUN apt update && apt install gettext-base
RUN mkdir -p /etc/nginx/ssl

RUN apt install -y nginx openssl curl && \
    rm -rf /var/lib/apt/lists/* && \
    openssl req -x509 \
        -nodes \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -days 365 \
        -subj "/CN=${DOMAIN_NAME}}"

EXPOSE 443

COPY conf/config.conf /etc/nginx/nginx.tmp
RUN envsubst '${DOMAIN_NAME} ${WORDPRESS_PORT}' < /etc/nginx/nginx.tmp > /etc/nginx/nginx.conf

CMD [ "nginx", "-g", "daemon off;" ]