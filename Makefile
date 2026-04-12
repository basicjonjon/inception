RM = rm -rf

SRCS_DIR = srcs/
DOCKER_COMPOSE = $(SRCS_DIR)docker-compose.yml
REQ_DIR = $(SRCS_DIR)requirements
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

clean:
	docker compose -f srcs/docker-compose.yml down -v
	docker system prune -af
	sudo $(RM) $(MARIADB_DATA) $(WORDPRESS_DATA)
	@echo "$(RED)============== [VOLUMES DELETED] ==============$(NC)"

stop: clean
	docker stop nginx wordpress mariadb

rebuild: stop clean build 

access_mariadb:
	docker exec -it mariadb bash

access_nginx:
	docker exec -it nginx bash

access_wordpress:
	docker exec -it wordpress bash

.PHONY: start build clean rebuild access_mariadb access_nginx access_wordpress