#!/bin/bash

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

handle_error() {
    echo "Error occurred in script at line: $1"
    exit 1
}

log_timestamp() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S").$(date +%N | cut -b1-3)
    echo "$timestamp $1"
}

trap 'handle_error $LINENO' ERR

log_timestamp  "Starting entrypoint.sh..."

rndc-confgen -a -b 512 -c /etc/bind/rndc.key
chown root:bind /etc/bind/rndc.key
chmod 640 /etc/bind/rndc.key

log_timestamp "Starting cron service..."
service cron start
log_timestamp "Started cron service."

log_timestamp "Waiting for MySQL to be ready..."
until mysqladmin ping -h"db" -P"3306" --silent; do
    log_timestamp "MySQL is not ready yet, waiting..."
    sleep 5
done
log_timestamp "MySQL is ready."

log_timestamp "Running Python script, init_config"
python3 /scripts/init_config.py
log_timestamp "Running Python script, create_database"
python3 /scripts/create_database.py
log_timestamp "Running Python script, update_db_ext_blacklist"
python3 /scripts/update_db_ext_blacklist.py
log_timestamp "Running Python script, update_bind_blacklist"
python3 /scripts/update_bind_blacklist.py

(echo "$BIND_REFRESH_BLACKLIST_CRONJOB python3 /scripts/update_bind_blacklist.py") | crontab -
(echo "$EXT_BLACKLIST_CRONJOB python3 /scripts/update_db_ext_blacklist.py") | crontab -

log_timestamp "Container is running..."
tail -f /dev/null