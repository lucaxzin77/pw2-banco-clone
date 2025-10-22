# Nome do container do MySQL no Docker
CONTAINER_NAME=mysql_db
DB_USER=root
DB_PASS=root
DB_NAME=sistema_bancario

# Caminho para os arquivos SQL
SCHEMA=./MySQL/schema.sql
INSERTS=./MySQL/inserts.sql
PROCEDURES=./MySQL/procedures.sql

# Apaga e recria apenas o schema
reset-schema:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(SCHEMA)

# Cria procedures
create-procedures:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(PROCEDURES)

# Apaga e recria o schema e popula com dados iniciais
reset-db:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) < $(SCHEMA)
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(PROCEDURES)
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(INSERTS)
# Executa apenas o seed (dados iniciais)
inserts:
	docker exec -i $(CONTAINER_NAME) mysql -u $(DB_USER) -p$(DB_PASS) $(DB_NAME) < $(INSERTS)

build:
	docker compose build --no-cache

start:
	docker compose up -d

stop:
	docker compose down -v

restart: 
	stop start

logs:
	docker logs -f web