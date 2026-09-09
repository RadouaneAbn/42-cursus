FROM debian:trixie-backports

RUN mkdir -p /etc/nginx/ssl

RUN apt update && \
    apt install -y nginx openssl curl && \
    rm -rf /var/lib/apt/lists/* && \
    openssl req -x509 \
        -nodes \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -days 365 \
        -subj "/CN=rabounou.42.fr"

EXPOSE 443

COPY conf/config.conf /etc/nginx/nginx.conf

# ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "nginx", "-g", "daemon off;" ]