#!/bin/sh
set -e

if [ -f artisan ]; then
    if [ -z "$APP_KEY" ]; then
        echo "APP_KEY environment variable is not set. Refusing to start." >&2
        exit 1
    fi

    php artisan package:discover --ansi
    php artisan config:cache
    php artisan route:cache
    php artisan view:cache
    php artisan storage:link || true
fi

exec "$@"
