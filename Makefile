RM = rm -rf

DOCKER_COMPOSE = srcs/docker-compose.yml
SRCS_DIR = ./srcs/
REQ_DIR = $(SRCS_DIR)/requirements
MARIADB_DATA = /home/${USER}/data/mariadb/*
WORDPRESS_DATA = /home/${USER}/data/wordpress/*

GREEN = \033[1;32m
BLUE =  \033[1;34m
RED = \033[1;31m
NC = \033[0m

build:
	@echo "$(GREEN)================= [ BUILD ] =================$(NC)"
	docker compose -f $(DOCKER_COMPOSE) up --build

start:
	@echo "\n$(BLUE)================= [ START ] =================$(NC)\n"
	docker compose -f $(DOCKER_COMPOSE) up

stop:
	docker stop nginx wordpress mariadb

clean:
	docker system prune -af
	sudo $(RM) $(MARIADB_DATA) $(WORDPRESS_DATA)
	@echo "$(RED)============== [VOLUMES DELETED] ==============$(NC)"

rebuild: stop clean build 

access_mariadb:
	docker exec -it mariadb bash

access_nginx:
	docker exec -it nginx bash

access_wordpress:
	docker exec -it wordpress bash

.PHONY: start build clean rebuild access_mariadb access_nginx access_wordpress