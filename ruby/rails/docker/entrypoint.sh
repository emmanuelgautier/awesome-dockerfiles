#!/bin/bash
set -e

if [ -z "$SECRET_KEY_BASE" ] && [ -z "$RAILS_MASTER_KEY" ]; then
    echo "Neither SECRET_KEY_BASE nor RAILS_MASTER_KEY is set. Refusing to start." >&2
    exit 1
fi

rm -f tmp/pids/server.pid

if [ "$1" = "./bin/rails" ] && [ "$2" = "server" ]; then
    ./bin/rails db:prepare
fi

exec "$@"
