#!/usr/bin/env bash
# Utility to collect InifiniMetrics logs from self-hosted environment 

show_help() {
  cat <<EOF
Usage: $0 [options] --since <date>

Collect logs 

Options:
 -h, --help    Show this message
 --since       Since when to start the logs collection [YYYY-MM-DD]
EOF
}

SINCE="${SINCE:-}"

while (($#)); do
  case "$1" in
  -h | --help)
    show_help
    exit
    ;;
  --since) 
    SINCE="$2"
    shift 
    shift
    ;;
  *)
    echo "Unexpected argument: $1. Use --help for usage information."
    exit 1
    ;;
  esac
  shift
done

if [ -z "$SINCE" ]; then
    show_help
    exit 1
fi

echo "Starting collecting logs since $SINCE"

echo "=========================================="

echo "Docker process output:"

docker compose ps

echo "=========================================="

echo "Supervisor status:"

docker compose exec collect_stats supervisorctl status

echo "=========================================="

echo "Docker logs output:"

docker compose logs --since "$SINCE"

echo "=========================================="

echo "Logs collection ended."
