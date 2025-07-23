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

LOGS_FILE="./data/logs/docker_logs_$SINCE.log"

collect_command(){
  echo "Collecting $1"
  echo "--------------" >> "$LOGS_FILE"
  echo "Collecting $1" >> "$LOGS_FILE"
  echo "--------------" >> "$LOGS_FILE"
  $1 >> "$LOGS_FILE" 2>&1
}

collect_command_and_print(){
  echo "$1"
  echo "$1" >> "$LOGS_FILE" 2>&1
}

echo "" > "$LOGS_FILE"

collect_command_and_print "=========================================="

collect_command_and_print "Starting collecting logs since $SINCE"

collect_command_and_print "=========================================="

collect_command_and_print "Collecting general docker information"

collect_command "docker info"
collect_command "docker version"
collect_command "docker compose version "
collect_command "docker system df"
collect_command "docker network ls"
collect_command "docker inspect host"
collect_command "docker inspect bridge"
collect_command "systemctl status docker"
collect_command "docker container ls"
collect_command "docker ps -a"
collect_command "docker inspect infinimetrics_web"
collect_command "docker inspect infinimetrics_clickhouse"
collect_command "docker inspect infinimetrics_postgres"
collect_command "docker inspect infinimetrics_nginx"
collect_command "docker inspect infinimetrics_cron"
collect_command "docker inspect infinimetrics_collect_stats"

collect_command_and_print "=========================================="

collect_command_and_print "Collecting Docker process output..."

collect_command "docker compose ps"

collect_command_and_print "=========================================="

collect_command_and_print "Collecting supervisor status..."

collect_command "docker compose exec collect_stats supervisorctl status"

collect_command_and_print "=========================================="

collect_command_and_print "Collecting Docker logs since $SINCE"

collect_command "docker compose logs --since $SINCE"

collect_command_and_print "=========================================="

collect_command_and_print "Logs collection were succesfully saved into $LOGS_FILE"
