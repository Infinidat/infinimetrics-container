#!/usr/bin/env bash

exec docker compose exec -it web infinimetrics "$@"
