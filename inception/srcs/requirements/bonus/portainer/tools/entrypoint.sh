#!/bin/bash

exec /opt/portainer/portainer --http-enabled --bind ":${PORTAINER_PORT}"