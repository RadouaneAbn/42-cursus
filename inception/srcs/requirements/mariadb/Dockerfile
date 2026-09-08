FROM debian:trixie-backports

# RUN apt update && apt install -y mariadb-server mariadb-client && rm -rf /var/lib/apt/lists/*
RUN apt update
RUN apt install -y mariadb-server mariadb-client
RUN rm -rf /var/lib/apt/lists/*

COPY tools/entrypoint.sh .

RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT [ "/entrypoint.sh" ]

CMD ["mariadbd", "--user=mysql"]