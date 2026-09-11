# User Documentation

## What the stack provides

This project runs a small web stack with the following services:

- **Nginx**: HTTPS reverse proxy and public entry point.
- **WordPress**: the main website and blog platform.
- **MariaDB**: the database used by WordPress.
- **Adminer**: a web database administration tool.
- **Portainer**: a web interface to manage Docker resources.
- **Static website**: a simple bonus page served separately.

## Start and stop the project

From the project root, use the Makefile:

- `make up` or `make` or `make all`: build the images and start the containers.
- `make down`: stop the containers.
- `make re`: rebuild everything from scratch and start again.

Useful checks:

- `make ps`: show the running containers.
- `make logs`: follow the container logs.

## Access the website and admin panels

The public website is served through Nginx over HTTPS.

- Open: `https://<DOMAIN_NAME>`
- The domain name is set in `srcs/.env`.

Administration access:

- **WordPress admin dashboard**: `https://<DOMAIN_NAME>/wp-admin`
- **Adminer**: `https://<DOMAIN_NAME>/adminer/`
- **Portainer**: `https://<DOMAIN_NAME>/portainer/`
- **Static website**: `https://<DOMAIN_NAME>/static/`

## Locate and manage credentials

Credentials are not stored inside the code. They are read from the files in the `secrets/` directory:

- `secrets/db_root_pass.txt`
- `secrets/db_user_pass.txt`
- `secrets/wp_admin_pass.txt`
- `secrets/wp_user_pass.txt`

The `.env` file in `srcs/.env` tells the stack where to find those files.

If a password must be changed:

1. Edit the matching file in `secrets/`.
2. Restart the stack with `make down && make up`.

## Check that services are running correctly

You can verify the stack with these checks:

- `make ps` to confirm the containers are running.
- `make logs` to watch for startup errors.
- Open the website in a browser and confirm the WordPress homepage loads.
- Try the admin dashboard, Adminer, or Portainer links.

Health checks are also configured for WordPress and MariaDB, so containers will report unhealthy if their internal checks fail.
