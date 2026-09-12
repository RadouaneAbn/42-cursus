FROM debian:bookworm

ARG PORTAINER_PORT
ENV PORTAINER_PORT=${PORTAINER_PORT}

COPY tools/entrypoint.sh /entrypoint.sh
COPY tools/healthcheck.sh /healthcheck.sh
RUN chmod +x /entrypoint.sh
RUN chmod +x /healthcheck.sh

RUN apt update && apt install -y curl ca-certificates

WORKDIR /opt/portainer

RUN curl -L https://github.com/portainer/portainer/releases/download/2.45.0/portainer-2.45.0-linux-amd64.tar.gz \
    -o portainer.tar.gz

RUN tar -xvzf portainer.tar.gz --strip-components=1 && \
    rm portainer.tar.gz

EXPOSE ${PORTAINER_PORT}

ENTRYPOINT [ "/entrypoint.sh" ]