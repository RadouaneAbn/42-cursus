FROM debian:trixie-backports

# RUN apt update && apt install -y mariadb-server mariadb-client && rm -rf /var/lib/apt/lists/*
RUN apt update && apt install -y mariadb-server mariadb-client && apt install gettext-base && rm -rf /var/lib/apt/lists/*

EXPOSE 3306

COPY conf/init.sql /tmp

COPY tools/entrypoint.sh .
RUN chmod +x /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["mariadbd", "--user=mysql"]