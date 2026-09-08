

all: up

up:
	docker compose -f srcs/docker-compose.yml up --build

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker volume rm -f srcs_mariadb_vlm

fclean:
	docker rm -f maria-db
	docker rmi -f srcs-maria-db
	docker system prune -f

re: fclean up