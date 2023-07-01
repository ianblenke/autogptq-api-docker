all:
	docker-compose build
	docker-compose up --force-recreate -d
	docker-compose logs -f
