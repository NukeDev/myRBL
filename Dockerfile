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

FROM internetsystemsconsortium/bind9:9.16

RUN apt-get update && apt-get install -y python3 python3-pip cron mysql-client

COPY scripts/requirements.txt /scripts/requirements.txt

RUN pip3 install -r /scripts/requirements.txt

COPY scripts/update_bind_blacklist.py /scripts/update_bind_blacklist.py
COPY scripts/update_db_ext_blacklist.py /scripts/update_db_ext_blacklist.py
COPY scripts/init_config.py /scripts/init_config.py
COPY scripts/create_database.py /scripts/create_database.py
COPY scripts/checkzone.sh /scripts/checkzone.sh
COPY scripts/entrypoint.sh /scripts/entrypoint.sh

COPY config/named.conf.local /etc/bind/named.conf.local
COPY config/named.conf.options /etc/bind/named.conf.options

RUN mkdir -p /run/named /var/log/named /var/cache/bind
RUN touch /var/log/named.stats
RUN touch /etc/bind/db.blacklist

RUN chown -R bind:bind /run/named /var/cache/bind /etc/bind /var/log/named /var/log/named.stats && \
    chmod -R 755 /run/named /var/cache/bind /etc/bind /var/log/named
RUN chmod +x /scripts/checkzone.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]

