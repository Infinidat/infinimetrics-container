#!/usr/bin/env bash

exec docker compose --env-file .env --env-file .env.user run --rm -i web infinimetrics "$@"
