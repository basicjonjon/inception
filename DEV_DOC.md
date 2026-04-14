# Developer Documentation

## Project Overview

This project is a Docker-based infrastructure built as part of the 42 curriculum.

It consists of three main services:
- **NGINX**: reverse proxy and the only public entrypoint
- **WordPress**: PHP-FPM application
- **MariaDB**: database service

Each service runs in its own dedicated container and communicates through a Docker network.

The project is designed to be:
- reproducible
- modular
- isolated
- persistent thanks to Docker volumes

## Project Structure

```bash
.
├── DEV_DOC.md
├── Makefile
├── README.md
├── secrets
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs
    ├── docker-compose.yml
    ├── .env
    └── requirements
        ├── mariadb
        │   ├── conf
        │   │   └── 50-server.cnf
        │   ├── Dockerfile
        │   └── tools
        │       └── init.sh
        ├── nginx
        │   ├── conf
        │   │   └── nginx.conf
        │   └── Dockerfile
        └── wordpress
            ├── conf
            ├── Dockerfile
            └── tools
                └── init.sh
```

### Structure details

- `Makefile`: main entrypoint to build, start, stop, clean, and rebuild the infrastructure
- `secrets/credential.txt`: define database admin username
- `secrets/db_password.txt`: define database admin password
- `secrets/db_root_password.txt`: define database root password
- `srcs/.env`: define environement variables domain name & database name
- `srcs/docker-compose.yml`: defines services, volumes, and network
- `srcs/requirements/mariadb/`: MariaDB image, config, and initialization script
- `srcs/requirements/nginx/`: NGINX image and HTTPS configuration
- `srcs/requirements/wordpress/`: WordPress image and initialization script


## Prerequisites

### [install docker ](https://docs.docker.com/engine/install/)

### Optional: run Docker without sudo

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### install make (for ubuntu)
```bash
sudo apt-get install make
```
### create .env file 
```bash
touch srcs/.env
```
add DOMAIN_NAME and MYSQL_DATABASE environement variable
```
DOMAIN_NAME=login.42.fr
MYSQL_DATABASE=wordpress
```
### create secret file
```bash
mkdir -p secrets && touch secrets/credentials.txt secrets/db_password.txt secrets/db_root_password.txt
```
- credentials -> your admin username
- db_password -> your admin password
- credential -> your root password

### change host
in `/etc/hosts` add or  change 
```text
127.0.0.1 <42login>.42.fr
``` 

## Notes

- The `.env` file is used to centralize project configuration.
- It should never contain production credentials in a public repository.
- It makes the stack easier to configure and reuse.

### Secrets and sensitive data

Sensitive data must not be hardcoded in Dockerfiles or scripts.

Good practices:
- store configuration values in `.env` or `secrets/` files
- keep credentials out of Git
- use Docker secrets

# Build and Launch

## build the project

```bash
make
```

or

```bash
make build
```
or
```bash
docker compose -f srcs/docker-compose.yml up --build
```
These commands:
- build the Docker images
- create containers
- create the network
- create and attach the volumes
- start all services

## Start the project
```bash
make start
```
or
```bash
docker compose -f srcs/docker-compose.yml up
```
These commands:
- build the Docker images if doesn't exit
- start all services


## Stop the project

```bash
make stop
```
or
```bash
docker stop nginx wordpress mariadb
```

This command stops the running containers.
## Clean volumes and containers data

```bash
make clean
```
or 
```bash
    docker compose -f srcs/docker-compose.yml down -v
	docker system prune -af
    sudo rm -rf /home/${USER}/data/mariadb/* /home/${USER}/data/wordpress/*
```

This command removes project data depending on your.

Use it carefully, because persistent data may be deleted.

## Full rebuild

```bash
make rebuild
```

This command usually:
- stops the containers
- removes containers and volumes
- rebuilds images
- starts the stack again

It is useful after configuration changes or to reset the whole environment.



## Docker Commands for Development

### List running containers

```bash
docker ps
```

### List all containers

```bash
docker ps -a
```

### View logs of a container

```bash
docker logs <container_name>
```

### Access a running container shell

```bash
docker exec -it <container_name> bash
```
or 
```bash
make access_<container_name>
```

If `bash` is not available:

```bash
docker exec -it <container_name> sh
```

### List Docker volumes

```bash
docker volume ls
```

### Inspect Docker network

```bash
docker network ls
docker network inspect <network_name>
```



## Service Details

## NGINX

NGINX is the public entrypoint of the infrastructure.

Responsibilities:
- expose port **443**
- handle HTTPS connections
- enforce TLS
- forward requests to the WordPress service

Configuration file:

```text
srcs/requirements/nginx/conf/nginx.conf
```

Important points:
- NGINX must be the only exposed service
- only TLSv1.2 or TLSv1.3 should be enabled
- no HTTP public entrypoint should be used in the mandatory part



## WordPress

The WordPress container runs the application with PHP-FPM.

Responsibilities:
- provide the PHP application
- connect to MariaDB
- serve the WordPress website files
- initialize the WordPress installation

Initialization script:

```text
srcs/requirements/wordpress/tools/init.sh
```

Important points:
- no NGINX inside this container
- PHP-FPM should run as the main process
- WordPress files are stored in a persistent volume


## MariaDB

MariaDB is the database service for WordPress.

Responsibilities:
- create and manage the WordPress database
- create database users
- persist all database content

Configuration file:

```text
srcs/requirements/mariadb/conf/50-server.cnf
```

Initialization script:

```text
srcs/requirements/mariadb/tools/init.sh
```

Important points:
- no NGINX inside this container
- database data must persist through volumes
- credentials should come from environment variables or secrets

## Volumes and Data Persistence

The project uses Docker volumes to persist data.

Two persistent storages are required:
- one for the MariaDB database
- one for WordPress website files

### Why volumes are needed

Without volumes:
- deleting a container would remove all its data
- the database would be lost
- uploaded files and site content would disappear

With volumes:
- data survives container recreation
- the stack remains persistent and reusable

### Host storage location

According to the project requirements, volumes must store data inside:

```bash
/home/<login>/data/
```

Replace `<login>` with your 42 login.

### Examples of persisted data

- MariaDB tables and records
- WordPress uploads
- themes and plugins
- website configuration files


## Docker Network

All services communicate through a dedicated Docker network.

### Why use a Docker network

A Docker network allows containers to:
- communicate securely
- resolve each other by service name
- stay isolated from the host network

### Internal communication examples

- NGINX connects to `wordpress`
- WordPress connects to `mariadb`
