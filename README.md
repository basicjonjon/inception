*This project has been created as part of the 42 curriculum by jle-doua*
# Description

The aim of this project is to become familiar with **Docker** and **Docker Compose** by setting up an infrastructure composed of several services: an **Nginx web server**, a **MariaDB database** and a **WordPress application**.


___

# Instruction


**[install docker ](https://docs.docker.com/engine/install/)** 

install make (for ubuntu)
```
sudo apt-get install
```


## start docker
```
make
```
or
```
make build
```

## stop docker
```
make stop
```

## delete volume docker (mariadb && nginx)
```
make clean
```

## rebuild
stop docker if launch, delete docker volume and build docker again
```
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


___