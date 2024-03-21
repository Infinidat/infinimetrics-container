#!/usr/bin/env bash
set -eE

show_help() {
  cat <<EOF
Usage: $0 [options]

Install containerized InfiniMetrics in Self-Hosted environment.

Options:
 -h, --help           Show this message
 --noninteractive     Skip the interactive initialization prompt
 --start-containers   Start the containers automatically after install
 --skip-init          Skip database initialization/migration (not recommended)
EOF
}

NONINTERACTIVE="${NONINTERACTIVE:-}"
START_CONTAINERS="${START_CONTAINERS:-}"
SKIP_INIT="${SKIP_INIT:-}"

while (($#)); do
  case "$1" in
  -h | --help)
    show_help
    exit
    ;;
  --noninteractive) NONINTERACTIVE=1 ;;
  --start-containers) START_CONTAINERS=1 ;;
  --skip-init) SKIP_INIT=1 ;;
  *)
    echo "Unexpected argument: $1. Use --help for usage information."
    exit 1
    ;;
  esac
  shift
done
