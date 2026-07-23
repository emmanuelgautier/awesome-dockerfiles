#!/bin/sh
set -e

if [ -f artisan ]; then
    if [ -z "$APP_KEY" ]; then
        [ -f .env ] || cp .env.example .env
        php artisan key:generate --force
    fi

    php artisan package:discover --ansi
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    php artisan storage:link || true
fi

exec "$@"
