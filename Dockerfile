FROM internetsystemsconsortium/bind9:9.16

RUN apt-get update && apt-get install -y python3 python3-pip cron mysql-client

COPY scripts/requirements.txt /scripts/requirements.txt

RUN pip3 install -r /scripts/requirements.txt

COPY scripts/update_bind_blacklist.py /scripts/update_bind_blacklist.py
COPY scripts/update_db_ext_blacklist.py /scripts/update_db_ext_blacklist.py
COPY scripts/config.ini /scripts/config.ini
COPY scripts/init_config.py /scripts/init_config.py
COPY scripts/create_database.py /scripts/create_database.py
COPY config/named.conf.local /etc/bind/named.conf.local
COPY config/named.conf.options /etc/bind/named.conf.options
COPY config/db.blacklist /etc/bind/db.blacklist
COPY scripts/entrypoint.sh /scripts/entrypoint.sh


RUN mkdir -p /run/named /var/log/named /var/cache/bind
RUN touch /var/log/named.stats

RUN chown -R bind:bind /run/named /var/cache/bind /etc/bind /var/log/named /var/log/named.stats && \
    chmod -R 755 /run/named /var/cache/bind /etc/bind /var/log/named
    

ENTRYPOINT ["/scripts/entrypoint.sh"]

