#!/usr/bin/env bash

exec docker compose --env-file .env --env-file .env.use run --rm -i web infinimetrics "$@"
