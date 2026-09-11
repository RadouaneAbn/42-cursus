*This project has been created as part of the 42 curriculum by rabounou.*

# Inception

## Description

Inception is a small Docker-based infrastructure project. Its goal is to build and run a complete web stack made of several isolated services that work together:

- **Nginx** as the HTTPS reverse proxy and public entry point.
- **WordPress** as the main website.
- **MariaDB** as the database.
- **Adminer** as a database administration tool.
- **Portainer** as a Docker management interface.
- **A static website** as the bonus service.

## Project description

The project is designed to show how Docker can be used to run a multi-service application in a clean and reproducible way. The main design choices are:

- one Dockerfile per service;
- a single Docker Compose file to orchestrate everything;
- a private Docker network for internal communication;
- HTTPS access through Nginx only;
- persistent data stored on the host machine;
- credentials stored in secret files instead of hardcoded in the configuration.

The sources included in the project are the service files under srcs/requirements/, the Compose file in srcs/docker-compose.yml, the Makefile at the root, and the secret files in secrets/.

### Design choices and comparisons

#### Virtual Machines vs Docker

- **Virtual Machines** run a full guest operating system on top of the host.
- **Docker** shares the host kernel and runs isolated containers.
- Docker is lighter, faster to start, and easier to rebuild for this project.

#### Secrets vs Environment Variables

- **Environment variables** are useful for general configuration like ports, hostnames, and service names.
- **Secrets** are better for passwords and sensitive data.
- In this project, passwords are stored in files inside secrets/ and passed as Docker secrets, while non-sensitive values stay in srcs/.env.

#### Docker Network vs Host Network

- A **Docker network** keeps services isolated and lets containers talk to each other by name.
- A **host network** would expose services directly on the host network namespace.
- This project uses a bridge network because it is safer and keeps the services separated.

#### Docker Volumes vs Bind Mounts

- **Docker volumes** are managed by Docker.
- **Bind mounts** map container data to a directory on the host.
- This project uses host directories under /home/rabounou/data for persistence, so the database, WordPress files, and Portainer data remain available after containers are rebuilt.

## Instructions

### Requirements

- Docker
- Docker Compose plugin
- The project files and the secrets in secrets/

### Configuration

Before starting the project, check the environment file in srcs/.env and the password files in secrets/.

Required secret files:

- secrets/db_root_pass.txt
- secrets/db_user_pass.txt
- secrets/wp_admin_pass.txt
- secrets/wp_user_pass.txt

### Build and run

From the root of the repository:

- `make` or `make up` to build the images and start the stack.
- `make down` to stop the containers.
- `make re` to clean everything and start again.
- `make ps` to check the running containers.
- `make logs` to follow the logs.

The public website is available through Nginx over HTTPS at the domain defined in srcs/.env.

Useful URLs:

- WordPress: `https://<DOMAIN_NAME>`
- WordPress admin panel: `https://<DOMAIN_NAME>/wp-admin`
- Adminer: `https://<DOMAIN_NAME>/adminer/`
- Portainer: `https://<DOMAIN_NAME>/portainer/`
- Static website: `https://<DOMAIN_NAME>/static/`

## Resources

### Classic references

- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- Nginx documentation: https://nginx.org/en/docs/
- WordPress documentation: https://wordpress.org/documentation/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- Adminer: https://www.adminer.org/
- Portainer documentation: https://docs.portainer.io/

### AI usage

AI was used to help draft and organize this README, summarize the project files, and improve the wording of the documentation. The service layout, commands, paths, and configuration details were taken from the actual project files and then rewritten in a simpler form.

## More documentation

- [User documentation](USER_DOC.md)
- [Developer documentation](DEV_DOC.md)
