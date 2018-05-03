up:
	docker-compose build && docker-compose up -d && make logs
logs:
	docker-compose logs -f
down:
	docker-compose down
restart:
	make down && make up
hard_restart:
	make down && docker volume rm stackoverflowclon_db && make up
test:
	docker-compose exec web xvfb-run -a rspec
allure:
	allure serve gen/allure-results
critic:
	rubycritic
lint:
	rubocop -Ra
bash:
	docker-compose exec web bash
