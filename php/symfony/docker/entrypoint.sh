#!/bin/sh
set -e

if [ -z "$APP_SECRET" ]; then
    echo "APP_SECRET environment variable is not set. Refusing to start." >&2
    exit 1
fi

exec "$@"
