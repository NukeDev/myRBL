#!/bin/bash

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

CONFIG_FILE="/scripts/config.ini"

function read_ini() {
    SECTION=$1
    KEY=$2
    echo $(awk -F '=' -v section=$SECTION -v key=$KEY '
        $0 ~ "\\[" section "\\]" { in_section=1 }
        in_section && $0 ~ key "[[:space:]]*=" { print $2; exit }
        $0 ~ "\\[.*\\]" { in_section=0 }
    ' $CONFIG_FILE | tr -d ' ')
}


RBL_DOMAIN=$(read_ini "settings" "RBL_DOMAIN")

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


OUTPUT=$(named-checkzone rbl.$RBL_DOMAIN /etc/bind/db.blacklist)

if [[ "$OUTPUT" != *"OK"* ]]; then
    log_timestamp $OUTPUT
    log_timestamp " --------------- ERROR --------------- "
    log_timestamp " ------- !BIND ZONE NOT LOADED! ------ "
    log_timestamp " --------------- ERROR --------------- "
fi


(echo "0 * * * * python3 /scripts/update_bind_blacklist.py") | crontab -
(echo "0 0 * * * python3 /scripts/update_db_ext_blacklist.py") | crontab -

log_timestamp "Container is running..."
tail -f /dev/null