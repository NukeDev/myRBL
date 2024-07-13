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

if [[ -z "$CERTBOT_EMAIL" || -z "$RBL_DOMAIN" ]]; then
  echo "Error: CERTBOT_EMAIL and RBL_DOMAIN must be set"
  exit 1
fi

nginx &

sleep 5

certbot --nginx -n --agree-tos --email $CERTBOT_EMAIL -d rbl.$RBL_DOMAIN

envsubst '${RBL_DOMAIN}' < /etc/nginx/conf.d/default-ssl.conf.template > /etc/nginx/conf.d/default.conf

nginx -s reload
