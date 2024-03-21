#!/usr/bin/env bash

exec docker compose run --rm -i web infinimetrics "$@"
