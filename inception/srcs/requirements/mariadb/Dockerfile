FROM debian:trixie-backports

ARG DB_PORT

# RUN apt update && apt install -y mariadb-server mariadb-client && rm -rf /var/lib/apt/lists/*
RUN apt update && \
    apt install -y mariadb-server mariadb-client && \
    apt install -y gettext-base && \
    rm -rf /var/lib/apt/lists/*

EXPOSE ${DB_PORT}

COPY conf/init.sql /tmp

COPY tools/entrypoint.sh .
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["mariadbd", "--user=mysql", "--bind-address=0.0.0.0"]
