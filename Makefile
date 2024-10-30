#!make

SERVICE_NAME=gestion_mantenimiento_db
FRONTEND_SERVICE_NAME=gestion_mantenimiento_frontend
BACKEND_SERVICE_NAME=gestion_mantenimiento_backend

HOST=127.0.0.1
PORT=3306

PASSWORD=${MYSQL_ROOT_PASSWORD}
DATABASE=${MYSQL_DATABASE}
USER=${MYSQL_USER}

DOCKER_COMPOSE_FILE=./docker-compose.yml
DATABASE_CREATION=./db/init.sql
DATABASE_POPULATION=./db/data.sql

FILES=vistas funciones stored_procedures triggers user_roles


.PHONY: all up db-objects backend frontend logs test-db access-db down clean restart

all: info up db-objects

info:
	@echo "This is a project for $(DATABASE)"

# Levantar todos los servicios (base de datos, backend y frontend)
up:
	@echo "Create the instance of docker"
	docker compose -f $(DOCKER_COMPOSE_FILE) up -d --build

	@echo "Waiting for MySQL to be ready..."
	bash mysql_wait.sh

	@echo "Importing database scripts"
	docker exec -it $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD) -e "source $(DATABASE_CREATION);"
	docker exec -it $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD) --local-infile=1 -e "source $(DATABASE_POPULATION);"

# Crear objetos de base de datos adicionales (vistas, procedimientos almacenados, etc.)
db-objects:
	@echo "Create objects in database"
	@for file in $(FILES); do \
	    echo "Process $$file and add to the database: $(DATABASE)"; \
	    docker exec -it $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD) -e "source ./Proyecto_centro_logistico/database_objects/$$file.sql"; \
	done

# Levantar el backend
backend:
	@echo "Starting backend service"
	docker compose up -d $(BACKEND_SERVICE_NAME)

# Levantar el frontend
frontend:
	@echo "Starting frontend service"
	docker compose up -d $(FRONTEND_SERVICE_NAME)

# Comandos de testing
test-db:
	@echo "Testing the tables"
	docker exec -it $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD) -e "source ./Proyecto_centro_logistico/check_db_objects.sql";

# Acceso directo a la base de datos
access-db:
	@echo "Access to db-client"
	docker exec -it $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD)

# Respaldo y restauración de la base de datos
backup-db:
	@echo "Back up database by structure and data"
	docker exec -it $(SERVICE_NAME) mysqldump --routines=true -u$(MYSQL_USER) -p$(PASSWORD) --host $(HOST) --port $(PORT) $(DATABASE) > ./backup/$(DATABASE)-backup.sql

restore-db:
	@echo "Restore database by structure and data"
	docker exec -i $(SERVICE_NAME) mysql -u$(MYSQL_USER) -p$(PASSWORD) < ./backup/$(DATABASE)-backup.sql

# Detener y eliminar todos los servicios
down:
	@echo "Removing services and database"
	docker compose -f $(DOCKER_COMPOSE_FILE) down

# Limpiar volúmenes y reiniciar el entorno desde cero
clean:
	@echo "Cleaning up all services, volumes, and networks"
	docker compose -f $(DOCKER_COMPOSE_FILE) down -v --remove-orphans
	@echo "Deleting all unused Docker volumes"
	docker volume prune -f
	@echo "Deleting all unused Docker networks"
	docker network prune -f

# Reiniciar todos los servicios
restart: down up

# Logs de todos los servicios
logs:
	@echo "Displaying logs from all services"
	docker compose logs -f
