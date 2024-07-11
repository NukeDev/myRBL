.PHONY: configure up down build all
CONFIG_FILE := scripts/config.ini

configure:
	@echo "Configuring environment variables from $(CONFIG_FILE)"
	@while IFS='=' read -r key value || [ -n "$$key" ]; do \
		key=$$(echo $$key | tr -d '[:space:]'); \
		value=$$(echo $$value | tr -d '[:space:]'); \
		if [ "$$key" ] && [ "$$value" ] && ! echo "$$key" | grep -q '^#'; then \
			export $$key="$$value"; \
			echo "export $$key=\"$$value\""; \
		fi; \
	done < $(CONFIG_FILE)


up: configure
	@echo "Starting docker-compose..."
	@docker-compose up -d

down:
	@echo "Stopping docker-compose..."
	@docker-compose down

build: 
	@echo "Building image..."
	@docker-compose build

all: down build up


.DEFAULT_GOAL := all