NAME				=	inception
FLAGS				=	-d --no-build

COMPOSE_FILE		=	srcs/docker-compose.yml
COMPOSE				=	docker compose -f $(COMPOSE_FILE)

GREEN				=	\033[0;32m
YELLOW				=	\033[0;33m
RED					=	\033[0;31m
RESET				=	\033[0m

AT					=	@
SILENT				=	> /dev/null 2>&1

ifdef DBG
	ifeq ($(DBG),1)
		AT		=
		SILENT	=
		FLAGS	=
	endif
endif

all: up

up: build
	@echo "$(YELLOW)⏳ starting containers...$(RESET)"
	$(AT) $(COMPOSE) up $(FLAGS) $(SILENT)
	@echo "$(GREEN)✅ Containers are up.$(RESET)"

build:
	@mkdir -p /home/rabounou/data/mariadb
	@mkdir -p /home/rabounou/data/wordpress
	@mkdir -p /home/rabounou/data/portainer
	@echo "$(YELLOW)⏳ Building containers...$(RESET)"
	$(AT) $(COMPOSE) build $(SILENT)
	@echo "$(GREEN)✅ Containers are built.$(RESET)"

down:
	@echo "$(YELLOW)⏳ Stopping containers...$(RESET)"
	$(AT) $(COMPOSE) down > /dev/null 2>&1
	@echo "$(GREEN)✅ Containers stopped.$(RESET)"

clean: down
	@echo "$(YELLOW)⏳ Removing volumes...$(RESET)"
	$(AT) $(COMPOSE) down --volumes > /dev/null 2>&1
	@echo "$(GREEN)✅ Volumes removed.$(RESET)"

fclean: clean
	@echo "$(YELLOW)⏳ Removing images...$(RESET)"
	$(AT) $(COMPOSE) down --rmi all > /dev/null 2>&1
	@echo "$(GREEN)✅ Images removed.$(RESET)"

purge: fclean
	@echo "$(RED)⏳ Pruning entire docker system...$(RESET)"
	$(AT)docker system prune -af --volumes > /dev/null 2>&1
	@echo "$(GREEN)✅ System pruned.$(RESET)"

re: fclean up

ps:
	$(AT)$(COMPOSE) ps

logs:
	$(AT)$(COMPOSE) logs -f

.PHONY: all up down clean fclean purge re status logs