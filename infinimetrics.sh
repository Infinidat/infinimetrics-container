#!/usr/bin/env bash
set -e

dc="docker compose --env-file .env --env-file .env.user --progress quiet"

if [ "$#" -lt 1 ] ; then
    $dc run --rm web infinimetrics
    exit 1
fi

cmd="$1"
nextarg="$2"

if [[ "$cmd" == "restore" ]] && [[ ! "$nextarg" = "/tmp/infinimetrics/"* ]]  ; then
    echo "ERROR: The path must start with /tmp/infinimetrics/" >&2
    exit 1
fi

if [[ "$cmd" == "add" || "$cmd" == "restore" || "$cmd" == "delete" || "$cmd" == "migrate_over_ssh" ]] ; then
    # Requires reloading gunicorn, so we must exec against a running service
    exec $dc exec web infinimetrics "$@"
else
    # May be executed in a separate instance, doesn't require reloading gunicorn
    exec $dc run --rm web infinimetrics "$@"
fi
