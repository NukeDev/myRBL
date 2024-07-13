# =============================================================================
# myRBL Dockerized
# 
# Copyright (C) 2024 [NukeDev - Gianmarco Varriale]
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.
# =============================================================================

CONFIG_FILE := config.ini

ifneq ("$(wildcard $(CONFIG_FILE))","")
	include $(CONFIG_FILE)
else
$(error Config file $(CONFIG_FILE) not found. Aborting.)
endif

export DB_USER := $(DB_USER)
export DB_PASSWORD := $(DB_PASSWORD)
export DB_HOST := $(DB_HOST)
export DB_NAME := $(DB_NAME)
export RBL_DOMAIN := $(RBL_DOMAIN)
export NS_PUBLIC_IP_ADDRESS := $(NS_PUBLIC_IP_ADDRESS)
export STAMPARM_URL_EXT_IP_ADDRESSES_BLACKLIST := $(STAMPARM_URL_EXT_IP_ADDRESSES_BLACKLIST)
export URL_EXT_DOMAINS_BLACKLIST := $(URL_EXT_DOMAINS_BLACKLIST)
export EXT_BLACKLIST_CRONJOB := $(EXT_BLACKLIST_CRONJOB)
export BIND_REFRESH_BLACKLIST_CRONJOB := $(BIND_REFRESH_BLACKLIST_CRONJOB)
export CERTBOT_EMAIL := $(CERTBOT_EMAIL)
export USE_SSL := $(USE_SSL)

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