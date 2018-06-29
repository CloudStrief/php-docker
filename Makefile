build:
	cp .env-dist .env
	docker-compose build --force-rm
	docker-compose up -d

start:
	docker-compose start

status:
	docker-compose ps

stop:
	docker-compose stop

php-cli:
	docker-compose run --rm php bash

down:
	docker-compose down --rmi local
	rm .env
