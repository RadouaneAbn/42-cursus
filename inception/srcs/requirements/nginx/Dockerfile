FROM debian:trixie-backports

ARG DOMAIN_NAME
ENV DOMAIN_NAME=${DOMAIN_NAME}

RUN mkdir -p /etc/nginx/ssl

RUN apt update && \
    apt install -y nginx openssl curl gettext-base && \
    rm -rf /var/lib/apt/lists/* && \
    openssl req -x509 \
        -nodes \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -days 365 \
        -subj "/CN=${DOMAIN_NAME}}"

EXPOSE 443

COPY conf/config.conf /etc/nginx/nginx.conf
RUN envsubst < /etc/nginx/nginx.conf > /etc/nginx/nginx.conf

CMD [ "nginx", "-g", "daemon off;" ]