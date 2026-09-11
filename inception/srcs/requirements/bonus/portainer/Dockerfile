FROM debian:13

RUN apt update && apt install -y curl ca-certificates

WORKDIR /opt/portainer

RUN curl -L https://github.com/portainer/portainer/releases/download/2.45.0/portainer-2.45.0-linux-amd64.tar.gz \
    -o portainer.tar.gz

RUN tar -xvzf portainer.tar.gz --strip-components=1 && \
    rm portainer.tar.gz

EXPOSE 9443

CMD [ "/opt/portainer/portainer" ]