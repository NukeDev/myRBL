include config.ini

export DB_USER := $(DB_USER)
export DB_PASSWORD := $(DB_PASSWORD)
export DB_HOST := $(DB_HOST)
export DB_NAME := $(DB_NAME)
export RBL_DOMAIN := $(RBL_DOMAIN)
export NS_PUBLIC_IP_ADDRESS := $(NS_PUBLIC_IP_ADDRESS)
export URL_EXT_IP_ADDRESSES_BLACKLIST := $(URL_EXT_IP_ADDRESSES_BLACKLIST)
export URL_EXT_DOMAINS_BLACKLIST := $(URL_EXT_DOMAINS_BLACKLIST)

.PHONY: up down build all

up: 
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