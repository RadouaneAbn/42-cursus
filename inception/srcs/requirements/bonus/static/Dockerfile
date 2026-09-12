FROM debian:bookworm

ARG STATIC_WEBSITE_PORT

RUN apt update && \
    apt install -y nginx curl ca-certificates gettext-base && \
    rm -rf /var/lib/apt/lists/*

COPY tools/index.html /var/www/html/index.html
COPY conf/nginx.conf /etc/nginx/nginx.tmp
COPY tools/healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

RUN envsubst '${STATIC_WEBSITE_PORT}' \
    < /etc/nginx/nginx.tmp > /etc/nginx/nginx.conf && \
    rm /etc/nginx/nginx.tmp

EXPOSE ${STATIC_WEBSITE_PORT}

CMD ["nginx", "-g", "daemon off;"]