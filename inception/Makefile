COMPOSE_FILE = srcs/docker-compose.yml
COMPOSE     = docker compose -f $(COMPOSE_FILE)

GREEN       = \033[0;32m
YELLOW      = \033[0;33m
RED         = \033[0;31m
RESET       = \033[0m

DATA_DIR    = /home/rabounou/data

all: up

up: build
	@echo "$(YELLOW)Starting containers...$(RESET)"
	@$(COMPOSE) up -d
	@echo "$(GREEN)Containers are up.$(RESET)"

build:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	@mkdir -p $(DATA_DIR)/portainer
	@echo "$(YELLOW)Building images...$(RESET)"
	@$(COMPOSE) build
	@echo "$(GREEN)Images are built.$(RESET)"

down:
	@echo "$(YELLOW)Stopping containers...$(RESET)"
	@$(COMPOSE) down
	@echo "$(GREEN)Containers stopped.$(RESET)"

clean: down
	@echo "$(YELLOW)Removing images...$(RESET)"
	@$(COMPOSE) down --rmi all
	@echo "$(GREEN)Images removed.$(RESET)"

fclean: clean
	@echo "$(YELLOW)Removing volumes and data...$(RESET)"
	@$(COMPOSE) down --volumes
	@sudo rm -rf $(DATA_DIR)
	@echo "$(GREEN)Volumes and data removed.$(RESET)"

re: fclean up

ps:
	@$(COMPOSE) ps

logs:
	@$(COMPOSE) logs -f

.PHONY: all up build down clean fclean re ps logs