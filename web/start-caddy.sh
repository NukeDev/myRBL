#!/bin/sh

envsubst < /etc/caddy/Caddyfile.template > /etc/caddy/Caddyfile

if [ "$USE_SSL" = "true" ]; then
    cat >> /etc/caddy/Caddyfile <<EOL
https://rbl.${RBL_DOMAIN} {
    root * /var/www/html
    php_fastcgi php:9000
    file_server
    tls {
        cert_file /etc/ssl/caddy/cert.pem
        key_file /etc/ssl/caddy/key.pem
    }
    log {
        output file /var/log/caddy/rbl-https.log
        format json
    }
}
EOL
fi

caddy run --config /etc/caddy/Caddyfile