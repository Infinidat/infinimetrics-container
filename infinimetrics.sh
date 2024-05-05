#!/usr/bin/env bash
set -e

dc="docker compose --env-file .env --env-file .env.user --progress quiet"

if [ "$#" -lt 1 ] ; then
    $dc run -T web infinimetrics --help
    echo "ERROR: Illegal number of parameters (requires at least 1)" >&2
    exit 1
fi

cmd="$1"
nextarg="$2"

if [[ "$cmd" == "restore" ]] && [[ ! "$nextarg" = "/tmp/infinimetrics/"* ]]  ; then
    echo "ERROR: The path must start with /tmp/infinimetrics/" >&2
    exit 1
fi

if [[ "$cmd" == "add" ]] || [[ "$cmd" == "restore" ]] || [[ "$cmd" == "delete" ]] ; then
    $dc run --rm web infinimetrics "$@"
    echo "INFO: Reloading web container ..." >&2
    $dc kill -s SIGHUP web
else
    exec $dc run --rm web infinimetrics "$@"
fi
