# Developer Documentation

## 1. Project Overview

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

---

## 2. Project Structure

```bash
.
├── Makefile
├── README.md
└── srcs
    ├── docker-compose.yml
    └── requirements
        ├── mariadb
        │   ├── conf
        │   │   └── 50-server.cnf
        │   ├── Dockerfile
        │   ├── .dockerignore
        │   └── tools
        │       └── init.sh
        ├── nginx
        │   ├── conf
        │   │   └── nginx.conf
        │   ├── Dockerfile
        │   └── .dockerignore
        └── wordpress
            ├── Dockerfile
            ├── .dockerignore
            └── tools
                └── init.sh
```

### Structure details

- `Makefile`: main entrypoint to build, start, stop, clean, and rebuild the infrastructure
- `srcs/docker-compose.yml`: defines services, volumes, and network
- `srcs/requirements/mariadb/`: MariaDB image, config, and initialization script
- `srcs/requirements/nginx/`: NGINX image and HTTPS configuration
- `srcs/requirements/wordpress/`: WordPress image and initialization script

---

## 3. Prerequisites

Before setting up the project, make sure the following tools are installed on your machine:

- Docker
- Docker Compose
- Make

### Ubuntu installation

```bash
sudo apt update
sudo apt install docker.io docker-compose make
```

### Optional: run Docker without sudo

```bash
sudo usermod -aG docker $USER
newgrp docker
```

---

## 4. Environment Setup

## 4.1 `.env` file

The project uses environment variables stored in a `.env` file.

Example:

```env
DOMAIN_NAME=yourlogin.42.fr
MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=wp_password
MYSQL_ROOT_PASSWORD=root_password
WORDPRESS_TITLE=Inception
WORDPRESS_ADMIN_USER=wpadmin
WORDPRESS_ADMIN_PASSWORD=admin_password
WORDPRESS_ADMIN_EMAIL=admin@example.com
WORDPRESS_USER=user42
WORDPRESS_USER_EMAIL=user42@example.com
WORDPRESS_USER_PASSWORD=user_password
```

### Notes

- The `.env` file is used to centralize project configuration.
- It should never contain production credentials in a public repository.
- It makes the stack easier to configure and reuse.

---

## 4.2 Secrets and sensitive data

Sensitive data must not be hardcoded in Dockerfiles or scripts.

Good practices:
- store configuration values in `.env`
- keep credentials out of Git
- use Docker secrets if implemented in the project

---

## 5. Build and Launch

## 5.1 Start the project

```bash
make
```

or

```bash
make build
```

These commands:
- build the Docker images
- create containers
- create the network
- create and attach the volumes
- start all services

---

## 5.2 Stop the project

```bash
make stop
```

This command stops the running containers.

---

## 5.3 Clean volumes and containers data

```bash
make clean
```

This command removes project data depending on your Makefile implementation.

Use it carefully, because persistent data may be deleted.

---

## 5.4 Full rebuild

```bash
make rebuild
```

This command usually:
- stops the containers
- removes containers and volumes
- rebuilds images
- starts the stack again

It is useful after configuration changes or to reset the whole environment.

---

## 6. Docker Commands for Development

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

---

## 7. Service Details

## 7.1 NGINX

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

---

## 7.2 WordPress

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

---

## 7.3 MariaDB

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

---

## 8. Initialization Logic

The project uses custom initialization scripts to configure services automatically.

## 8.1 MariaDB initialization

The MariaDB `init.sh` script usually:
- starts MariaDB setup
- creates the database
- creates a dedicated user
- applies privileges
- launches the database service properly

## 8.2 WordPress initialization

The WordPress `init.sh` script usually:
- waits for the database to become available
- downloads or prepares WordPress files
- creates `wp-config.php`
- configures database access
- creates the admin user
- creates an additional user if required
- starts PHP-FPM in foreground mode

---

## 9. Volumes and Data Persistence

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

---

## 10. Docker Network

All services communicate through a dedicated Docker network.

### Why use a Docker network

A Docker network allows containers to:
- communicate securely
- resolve each other by service name
- stay isolated from the host network

### Internal communication examples

- NGINX connects to `wordpress`
- WordPress connects to `mariadb`

### Forbidden networking choices in the mandatory part

The project must not use:
- `network_mode: host`
- `--link`
- `links:`

The communication must be handled by the Docker network defined in `docker-compose.yml`.

---

## 11. Data Flow

A request typically follows this path:

1. The browser accesses `https://<login>.42.fr`
2. NGINX receives the HTTPS request on port 443
3. NGINX forwards the request to WordPress
4. WordPress processes PHP code through PHP-FPM
5. WordPress communicates with MariaDB when database access is needed
6. The response goes back through NGINX to the browser

This architecture keeps each service focused on a single responsibility.

---

## 12. Development Workflow

A developer working on the project usually follows this workflow:

1. configure the `.env` file
2. check service configuration files
3. build the infrastructure with `make`
4. inspect logs if something fails
5. enter containers for debugging if needed
6. rebuild after changing Dockerfiles or scripts

Typical cycle:

```bash
make
docker ps
docker logs <container_name>
docker exec -it <container_name> sh
```

---

## 13. Troubleshooting

## 13.1 Containers do not start

Check all containers:

```bash
docker ps -a
```

Read logs:

```bash
docker logs <container_name>
```

Common causes:
- wrong environment variables
- invalid NGINX configuration
- MariaDB not initialized correctly
- WordPress trying to connect to the database too early

---

## 13.2 WordPress cannot connect to MariaDB

Check:
- database service name in `docker-compose.yml`
- database name
- database user
- database password
- startup order and readiness logic

Useful command:

```bash
docker logs <wordpress_container>
docker logs <mariadb_container>
```

---

## 13.3 HTTPS does not work

Check:
- NGINX configuration
- certificate path
- TLS settings
- domain name resolution

Also verify that your local domain points correctly to your machine.

Example host entry:

```bash
127.0.0.1 yourlogin.42.fr
```

---

## 13.4 Volume persistence does not work

Check:
- volume declarations in `docker-compose.yml`
- volume mount points
- host directory permissions
- actual location under `/home/<login>/data/`

Useful commands:

```bash
docker volume ls
docker volume inspect <volume_name>
```

---

## 13.5 Permission issues

If Docker cannot write to the data directory:

```bash
sudo chown -R $USER:$USER /home/<login>/data
```

Also verify directory existence and rights.

---

## 14. Important Project Constraints

This project follows the subject constraints.

### Main technical constraints

- one container per service
- one Dockerfile per service
- no pre-built service images except base Debian or Alpine
- no `latest` tag
- no hardcoded passwords in Dockerfiles
- use environment variables
- use a `.env` file
- use named volumes
- expose only port 443 through NGINX
- use TLSv1.2 or TLSv1.3 only
- no infinite loop hacks such as:
  - `tail -f`
  - `sleep infinity`
  - `while true`
  - starting a shell as the main process

### Architecture constraints

- NGINX only public entrypoint
- WordPress without NGINX
- MariaDB without NGINX
- dedicated Docker network
- persistent volumes for database and website files

---

## 15. Design Choices

## 15.1 Why Docker

Docker makes the project:
- reproducible on different machines
- easier to deploy
- easier to isolate
- easier to reset and rebuild

Instead of manually installing each service on the system, each service is packaged in its own image.

## 15.2 Why separate containers

Separating NGINX, WordPress, and MariaDB improves:
- modularity
- clarity
- maintainability
- debugging
- security through isolation

## 15.3 Why initialization scripts

Custom `init.sh` scripts allow:
- automatic setup
- deterministic container startup
- configuration from environment variables
- easier project reproduction from scratch

---

## 16. How to Extend the Project

To add a new service in the future:

1. create a new directory in `srcs/requirements/`
2. add a dedicated `Dockerfile`
3. add configuration files if needed
4. add the service to `docker-compose.yml`
5. connect it to the project network
6. attach a volume if persistent data is required
7. update the Makefile if necessary

Possible examples:
- Redis
- Adminer
- FTP
- static website
- any bonus service

---

## 17. Useful Commands Summary

### Start

```bash
make
```

### Stop

```bash
make stop
```

### Clean

```bash
make clean
```

### Rebuild

```bash
make rebuild
```

### Container list

```bash
docker ps
```

### Logs

```bash
docker logs <container_name>
```

### Shell access

```bash
docker exec -it <container_name> sh
```

---

## 18. Conclusion

This project demonstrates how to build a small but complete infrastructure with Docker.

It includes:
- service isolation
- HTTPS entrypoint with NGINX
- dynamic application with WordPress and PHP-FPM
- persistent database with MariaDB
- Docker networking
- persistent storage through named volumes
- reproducible setup through Dockerfiles, scripts, and Makefile

The project is structured so that a developer can clone it, configure it, build it, debug it, and extend it easily.
