FROM debian:13

RUN apt update && apt install -y gettext-base

ARG DB_PORT
EXPOSE ${DB_PORT}

COPY conf/init.sql /tmp

COPY tools/entrypoint.sh .
COPY tools/healthcheck.sh .
RUN chmod +x /entrypoint.sh
RUN chmod +x /healthcheck.sh

RUN apt install -y mariadb-server mariadb-client && \
    rm -rf /var/lib/apt/lists/*

COPY conf/50-server.cnf /tmp/50-server.tmp
RUN envsubst < /tmp/50-server.tmp \
    > /etc/mysql/mariadb.conf.d/50-server.cnf

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["mariadbd"]
