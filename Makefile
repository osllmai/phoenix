# Phoenix monorepo — pinned compose like health (never bare `docker compose`).
COMPOSE = docker compose --env-file .env -f docker/local/compose.yml
EDGE_COMPOSE = $(COMPOSE) -f docker/local/edge.yml
E2E_COMPOSE = $(COMPOSE) -f docker/local/playwright.yml
PROD_COMPOSE = docker compose --env-file .env -f docker/production/compose.yml -f docker/production/nginx.yml
API_PORT := $(or $(shell sed -n 's/^API_PORT=//p' .env 2>/dev/null),37000)

.PHONY: help up down full migrate migrations health test-backend test-mobile lint logs ps restart sh edge e2e up-prod down-prod logs-prod
.DEFAULT_GOAL := help

help:          ## list targets
	@grep -hE '^[a-z0-9-]+:.*##' $(MAKEFILE_LIST) | sort | awk -F':.*##' '{printf "  \033[36m%-14s\033[0m%s\n", $$1, $$2}'

up:            ## build + start the whole stack
	$(COMPOSE) up -d --build --remove-orphans

down:          ## stop + remove the stack
	$(COMPOSE) down

full: up migrations health   ## up + show migration status + health + ps (migrate is manual — consent gate)
	docker ps

migrate:       ## apply migrations
	$(COMPOSE) exec -T backend python manage.py migrate

migrations:    ## show migration status
	$(COMPOSE) exec -T backend python manage.py showmigrations

health:        ## poll API health (port from .env)
	@for i in $$(seq 1 15); do curl -fsS http://localhost:$(API_PORT)/api/v1/health/ && echo && exit 0; sleep 2; done; echo "health FAILED"; exit 1

test-backend:  ## pytest a=<app>
	$(COMPOSE) exec backend pytest apps/$(a) -q

test-mobile:   ## mobile unit (dart) + widget (flutter) tests
	bash mobile/tool/run_tests.sh

lint:          ## ruff check the backend
	$(COMPOSE) exec backend ruff check . --no-cache

logs:          ## follow logs for one service: s=<service>
	$(COMPOSE) logs -f $(s)

ps:            ## list the stack's containers
	$(COMPOSE) ps

restart:       ## restart a service (all if empty): s=<service>
	$(COMPOSE) restart $(s)

sh:            ## shell into a service (default backend): s=<service>
	$(COMPOSE) exec $(or $(s),backend) bash

edge:          ## local + nginx prod-edge rehearsal
	$(EDGE_COMPOSE) up -d

e2e:           ## run Playwright E2E against the local stack
	$(E2E_COMPOSE) run --rm playwright

up-prod:       ## prod stack (nginx + gunicorn), build & start
	$(PROD_COMPOSE) up -d --build

down-prod:     ## stop the prod stack
	$(PROD_COMPOSE) down

logs-prod:     ## s=<service>
	$(PROD_COMPOSE) logs -f $(s)
