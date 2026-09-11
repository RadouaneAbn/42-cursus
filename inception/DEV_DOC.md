# Developer Documentation

## Prerequisites

Before building the project, make sure the following are available:

- Docker
- Docker Compose plugin (`docker compose`)
- A Linux environment with permission to run Docker
- The project secrets files in `secrets/`
- The environment file in `srcs/.env`

## Configuration files and secrets

The project is configured mainly through:

- `srcs/.env` for service names, ports, and file paths
- `srcs/docker-compose.yml` for services, networks, volumes, and secrets
- `secrets/` for password files

The required secret files are:

- `secrets/db_root_pass.txt`
- `secrets/db_user_pass.txt`
- `secrets/wp_admin_pass.txt`
- `secrets/wp_user_pass.txt`

The Compose file mounts those files as Docker secrets. The `.env` file supplies the paths to them.

## Build and launch

The Makefile is the standard entry point.

From the project root:

- `make build`: create the host data directories and build the images.
- `make up`: build, then start all containers in detached mode.
- `make`: same as `make up`.
- `make re`: stop, remove volumes and data, then rebuild and start again.

Docker Compose is used through the Makefile with:

- `docker compose -f srcs/docker-compose.yml build`
- `docker compose -f srcs/docker-compose.yml up -d`

## Container and volume management

Useful Makefile commands:

- `make down`: stop the containers without deleting images or volumes.
- `make clean`: stop containers and remove images.
- `make fclean`: remove containers, images, volumes, and host data under `/home/rabounou/data`.
- `make ps`: list running containers.
- `make logs`: follow logs from all services.

## Data storage and persistence

Persistent data is stored on the host in:

- `/home/rabounou/data/mariadb`
- `/home/rabounou/data/wordpress`
- `/home/rabounou/data/portainer`

These paths are bind-mounted through named volumes in `srcs/docker-compose.yml`.

This means:

- MariaDB data survives container rebuilds.
- WordPress files and uploads survive container rebuilds.
- Portainer data survives container rebuilds.

The Makefile creates the host directories automatically when you run `make build` or `make up`.

## Service layout

The stack contains:

- `nginx`: public HTTPS reverse proxy
- `wordpress`: PHP-FPM application server
- `mariadb`: database server
- `adminer`: database admin tool
- `portainer`: Docker management UI
- `static_website`: bonus static site

Nginx routes traffic to the internal services through the Docker network.
