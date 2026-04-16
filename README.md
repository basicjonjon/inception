*This project has been created as part of the 42 curriculum by jle-doua*
# Description

The aim of this project is to become familiar with **Docker** and **Docker Compose** by setting up an infrastructure composed of several services: an **Nginx web server**, a **MariaDB database** and a **WordPress application**.

## Technical Choices and Comparisons

### Virtual Machines vs Docker

A **Virtual Machine** emulates a full operating system with its own kernel. It is heavier, uses more resources, and takes more time to start.  
**Docker**, on the other hand, uses containers that share the host kernel. Containers are lighter, faster to start, and easier to reproduce.

In this project, Docker is used because it allows each service to run in an isolated environment while staying lightweight and easy to manage.

### Secrets vs Environment Variables

**Environment variables** are simple to use and practical for configuration values such as a domain name or database name.  
However, they are not ideal for sensitive data because they may be exposed more easily.

**Secrets** are designed to store sensitive information such as passwords or private keys more securely. They reduce the risk of exposing confidential data in the project files.

In this project, environment variables are used for configuration, and secrets for sensitive values like passwords.


### Docker Network vs Host Network

A **Docker network** allows containers to communicate with each other in an isolated and controlled way. Each service can reach another service by its container name.  
A **host network** removes this isolation and makes the container use the host machine’s network directly.

In this project, a Docker network is used because it is safer, cleaner, and matches the subject requirements. It keeps the services isolated while still allowing communication between NGINX, WordPress, and MariaDB.


### Docker Volumes vs Bind Mounts

A **Docker volume** is managed by Docker and is mainly used for persistent data. It is portable, easier to manage, and better suited for databases and application data.  
A **bind mount** directly links a container path to a specific path on the host machine. It is useful during development, but it depends more on the host filesystem and is less portable.

In this project, i use bind mount because the subjet In this project, I'm using bind mount because the topic requires placing volumes in specific locations, which Docker Volumes doesn't allow.

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
### create .env file and secret file
```bash
mkdir -p secrets srcs && \
printf "DOMAIN_NAME=\nMYSQL_DATABASE=\nWP_TITLE=\nWP_ADMIN=\nWP_ADMIN_EMAIL=\nWP_ADMIN_PASSWORD=\nWP_USER=\nWP_USER_EMAIL=\nWP_USER_PASSWORD=\n" >> srcs/.env
touch secrets/{credentials.txt,db_password.txt,db_root_password.txt}
```
add your value in .env
```text
DOMAIN_NAME=login.42.fr
MYSQL_DATABASE=wordpress
WP_TITLE=inception
WP_ADMIN=WpAdminUserName
WP_ADMIN_EMAIL=WpAdminMail@gmail.com
WP_ADMIN_PASSWORD=XXXXXXX
WP_USER=WpUserName
WP_USER_EMAIL=WpUserMail@gmail.com
WP_USER_PASSWORD=XXXXXXX
```
- credentials -> your admin username
- db_password -> your admin password
- db_root_password -> your root password

### change host
in `/etc/hosts` add or  change 
```text
127.0.0.1 <42login>.42.fr
``` 
## start docker
```bash
make
```
or
```bash
make build
```

## stop docker
```bash
make stop
```

## delete volume docker (mariadb && nginx)
```bash
make clean
```

## rebuild
stop docker if launch, delete docker volume and build docker again
```bash
make rebuild
```

## access bash docker
running for
* mariadb
* nginx
* wordpress
```
make access_<dockerName>
```
# Resources
## param / use docker

[install docker](https://docs.docker.com/engine/install/ubuntu/)

[add user in docker group ](https://docs.docker.com/engine/install/linux-postinstall/)

[access docker bash](https://docs.docker.com/reference/cli/docker/container/exec/)

[docker ps](https://stackoverflow.com/questions/43721513/how-to-check-if-the-docker-engine-and-a-docker-container-are-running)

[choose debian version](https://www.debian.org/releases/index.fr.html)

## help
[tuto for project](https://tuto.grademe.fr/inception/)

## wordpress
[install wordpress](https://fr.wordpress.org/support/article/how-to-install-wordpress/)

## mariadb
[install mariadb](https://www.ionos.fr/digitalguide/hebergement/aspects-techniques/installer-mariadb-sous-debian-12/)

[param mariadb](https://www.malekal.com/mariadb-creer-base-de-donnees/#Comment_creer_une_base_de_donnees_sur_MariaDB_en_ligne_de_commandes)


## docker compose
[docker compose start](https://docs.docker.com/compose/gettingstarted/#step-1-set-up-the-project)

[docker compose volume](https://docs.docker.com/reference/compose-file/volumes/)

[docker compose secret](https://docs.docker.com/compose/how-tos/use-secrets/)

[docker compose network](https://docs.docker.com/compose/how-tos/networking/)

## nginx 
[param for wordpress](https://developer.wordpress.org/advanced-administration/server/web-server/nginx/)


