FROM debian:trixie-backports

RUN apt update && apt install -y gettext-base

ARG DB_PORT
EXPOSE ${DB_PORT}

COPY conf/init.sql /tmp

COPY tools/entrypoint.sh .

RUN chmod +x /entrypoint.sh

RUN apt install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["mariadbd", "--user=mysql", "--bind-address=0.0.0.0"]
