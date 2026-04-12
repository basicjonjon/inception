# User Documentation

## Overview

This project provides a small web infrastructure based on Docker.

The stack includes three services:
- **NGINX**: secure web entrypoint using HTTPS
- **WordPress**: website and administration panel
- **MariaDB**: database used by WordPress

As an end user or administrator, you can use this documentation to:
- understand what the project provides
- start and stop the stack
- access the website and the admin panel
- locate and manage credentials
- verify that the services are running correctly


## Services

### NGINX

NGINX is the only public entrypoint of the project.

It:
- listens on port **443**
- serves the website through **HTTPS**
- forwards requests to WordPress

### WordPress

WordPress provides:
- the public website
- the administration dashboard
- user management
- page and post creation
- media upload and website customization

### MariaDB

MariaDB stores the WordPress data, including:
- users
- posts
- pages
- settings
- comments


# Prerequisites


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
mkdir -p secrets && touch secrets/credential.txt secrets/db_password.txt secrets/db_root_password.txt
```
- credential -> your admin username
- db_password -> your admin password
- db_root_password -> your root password

### change host
in `/etc/hosts` add or  change 
```text
127.0.0.1 <42login>.42.fr
``` 
## Start the Project

To build and start the full stack, run:

```bash
make
```

or:

```bash
make build
```

This will:
- build the Docker images
- create the containers
- create the network
- attach the persistent volumes
- start all services

---

## Stop the Project

To stop the running containers:

```bash
make stop
```

This stops the project without necessarily deleting persistent data.

## Reset the project
To delete Volumes of wordpress and mariadb
```bash
make clean
```

## 6. Rebuild the Project

To fully rebuild the stack:

```bash
make rebuild
```

Use this if:
- you changed configuration files
- you changed Dockerfiles
- you want to reset the infrastructure

---

## Access the Website

Once the stack is running, open your browser and go to:

```text
https://<login>.42.fr
```

This is the public website served through NGINX and WordPress.

---

## Access the Administration Panel

To access the WordPress administration interface, open:

```text
https://<login>.42.fr/wp-admin
```

Log in using the administrator credentials defined during the WordPress setup.

## Credentials Management

The project uses environment variables and secrets to manage credentials.

Typical credentials include:
- MariaDB database name
- MariaDB username
- MariaDB password
- MariaDB root password

### Where to find credentials

Credentials are usually stored in:

```text
srcs/.env
```
or
```text
secrets/
```
and/or in secret files if your project uses them.

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

## Check That Services Are Running Correctly

### List running containers

```bash
docker ps
```

You should see the containers for:
- nginx
- wordpress
- mariadb

### Read logs

To inspect logs:

```bash
docker logs <container_name>
```

Examples:

```bash
docker logs nginx
```

```bash
docker logs wordpress
```

```bash
docker logs mariadb
```

### Functional checks

A correct setup usually means:
- `https://<login>.42.fr` loads in the browser
- `https://<login>.42.fr/wp-admin` is accessible
- WordPress can log in successfully
- pages and posts can be created
- the database remains available after restart


## Persistent Data

The project uses Docker volumes to keep data even if containers are removed.

Persistent data includes:
- MariaDB database files
- WordPress website files

According to the project rules, data is stored on the host under:

```text
/home/<login>/data/
```

This allows the website and database to survive container recreation.

## Basic Maintenance Commands

### Start

```bash
make
```

### Stop

```bash
make stop
```

### Clean data

```bash
make clean
```

### Rebuild

```bash
make rebuild
```

### Check logs

```bash
docker logs <container_name>
```

### Enter a container

```bash
docker exec -it <container_name> bash
```
or  
```bash
make access_<container_name>
```

## Summary

This project provides a complete Docker-based WordPress stack with:
- secure HTTPS access through NGINX
- a WordPress website and admin dashboard
- persistent MariaDB storage

Main access points:
- website: `https://<login>.42.fr`
- admin panel: `https://<login>.42.fr/wp-admin`

Main commands:
- `make`
- `make stop`
- `make clean`
- `make rebuild`

This file is intended to help any user or administrator quickly run, access, and verify the project.
