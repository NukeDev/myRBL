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

OUTPUT=$(named-checkzone rbl.$RBL_DOMAIN /etc/bind/db.blacklist)

if [[ "$OUTPUT" != *"OK"* ]]; then
    log_timestamp $OUTPUT
    log_timestamp " --------------- ERROR --------------- "
    log_timestamp " ------- !BIND ZONE NOT LOADED! ------ "
    log_timestamp " --------------- ERROR --------------- "
else
    log_timestamp $OUTPUT
    log_timestamp " --------------- !OK! ---------------- "
    log_timestamp " --------- !BIND ZONE LOADED! -------- "
    log_timestamp " --------------- !OK! ---------------- "
fi