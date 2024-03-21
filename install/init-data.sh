#!/usr/bin/env bash
set -eE

DEFAULT_DATA_DIR="./data"
DEFAULT_POSTGRES_DIR="./data/postgres"
DEFAULT_CLICKHOUSE_DIR="./data/clickhouse"
DEFAULT_LOGS_DIR="./data/logs"

DEFAULT_INFINIMETRICS_USER="infinimetrics"
DEFAULT_INFINIMETRICS_PASSWORD="infinimetrics"

ENV_DEFAULT=".env" 
ENV_USER=".env.user"

PERMS=755

source $ENV_DEFAULT

if [ "$NONINTERACTIVE" == "1" ] &&  [ ! -f "$ENV_USER" ]; then
    echo "DATA_DIR=$DEFAULT_DATA_DIR" >> $ENV_USER
    echo "LOGS_DIR=$DEFAULT_LOGS_DIR" >> $ENV_USER
    echo "CLICKHOUSE_DIR=$DEFAULT_CLICKHOUSE_DIR" >> $ENV_USER
    echo "POSTGRES_DIR=$DEFAULT_POSTGRES_DIR" >> $ENV_USER
    echo "POSTGRES_USER=$DEFAULT_INFINIMETRICS_USER"  >> $ENV_USER
    echo "POSTGRES_PASSWORD=$DEFAULT_INFINIMETRICS_PASSWORD"  >> $ENV_USER

    mkdir -p -m $PERMS "$DEFAULT_DATA_DIR"
    mkdir -p -m $PERMS "$DEFAULT_DATA_DIR/appdata"
    mkdir -p -m $PERMS "$DEFAULT_DATA_DIR/private"
    mkdir -p -m $PERMS "$DEFAULT_DATA_DIR/processes"
    mkdir -p -m $PERMS "$DEFAULT_DATA_DIR/tmp"

    mkdir -p -m $PERMS "$DEFAULT_LOGS_DIR"
    mkdir -p -m $PERMS "$DEFAULT_LOGS_DIR/collect_stats"
    mkdir -p -m $PERMS "$DEFAULT_LOGS_DIR/cron"

    mkdir -p -m $PERMS "$DEFAULT_POSTGRES_DIR"
    mkdir -p -m $PERMS "$DEFAULT_CLICKHOUSE_DIR"
fi
    
if [ -f "$ENV_USER" ]; then
    source $ENV_USER
    echo "INFO: Proceeding with existing custom $ENV_USER ..."
else 
    echo ""
    echo "================================================================="
    echo ""
    echo "   Starting InfiniMetrics initialization. "
    echo "   You will be prompted to change the default configuration."
    echo "   If you are not familiar with those settings, use provided defaults."
    echo ""
    echo "=================================================================="
    echo ""
    echo "INFO: $ENV_USER does not exist, initializing ..."
    
    echo "" > .env.tmp

    # Data directory configuration
    read -p "Data directory path [default: $DEFAULT_DATA_DIR] "  DATA_USER_DIR
    DATA_USER_DIR=${DATA_USER_DIR:-$DEFAULT_DATA_DIR}
    mkdir -p -m $PERMS "$DATA_USER_DIR"
    mkdir -p -m $PERMS "$DATA_USER_DIR/appdata"
    mkdir -p -m $PERMS "$DATA_USER_DIR/private"
    mkdir -p -m $PERMS "$DATA_USER_DIR/processes"
    mkdir -p -m $PERMS "$DATA_USER_DIR/tmp"
    echo "DATA_DIR=$DATA_USER_DIR"  >> .env.tmp

    # Logs directory
    read -p "Logs directory path [default: $DEFAULT_LOGS_DIR] "  LOGS_USER_DIR
    LOGS_USER_DIR=${LOGS_USER_DIR:-$DEFAULT_LOGS_DIR}
    if [ -d "$LOGS_USER_DIR" ]; then
        echo "WARNING: directory $DEFAULT_LOGS_DIR already exists."
    fi
    mkdir -p -m $PERMS "$LOGS_USER_DIR"
    mkdir -p -m $PERMS "$LOGS_USER_DIR/collect_stats"
    mkdir -p -m $PERMS "$LOGS_USER_DIR/cron"
    echo "LOGS_DIR=$LOGS_USER_DIR"  >> .env.tmp

    # Clickhouse configuration
    read -p "ClickHouse data directory path [default: $DEFAULT_CLICKHOUSE_DIR] "  CLICKHOUSE_USER_DIR
    CLICKHOUSE_USER_DIR=${CLICKHOUSE_USER_DIR:-$DEFAULT_CLICKHOUSE_DIR}
    if [ -d "$CLICKHOUSE_USER_DIR" ]; then
        echo "WARNING: directory $CLICKHOUSE_USER_DIR already exists."
    fi
    mkdir -p -m $PERMS "$CLICKHOUSE_USER_DIR"
    echo "CLICKHOUSE_DIR=$CLICKHOUSE_USER_DIR"  >> .env.tmp

    # Postgres configuration
    read -p "Postgres data directory path [default: $DEFAULT_POSTGRES_DIR] "  POSTGRES_USER_DIR
    POSTGRES_USER_DIR=${POSTGRES_USER_DIR:-$DEFAULT_POSTGRES_DIR}
    if [ -d "$POSTGRES_USER_DIR" ]; then
        echo "WARNING: directory $POSTGRES_USER_DIR already exists."
    fi
    mkdir -p -m $PERMS "$POSTGRES_USER_DIR"
    echo "POSTGRES_DIR=$POSTGRES_USER_DIR"  >> .env.tmp

    # Database credentials
    read -p "PostgresSQL username [default: $DEFAULT_INFINIMETRICS_USER] "  INFINIMETRICS_USER
    INFINIMETRICS_USER=${INFINIMETRICS_USER:-$DEFAULT_INFINIMETRICS_USER}
    echo "POSTGRES_USER=$INFINIMETRICS_USER"  >> .env.tmp

    read -p "PostgreSQL password [default: $DEFAULT_INFINIMETRICS_PASSWORD] "  INFINIMETRICS_PASSWORD
    INFINIMETRICS_PASSWORD=${INFINIMETRICS_PASSWORD:-$DEFAULT_INFINIMETRICS_PASSWORD}
    echo "POSTGRES_PASSWORD=$INFINIMETRICS_PASSWORD"  >> .env.tmp

    mv .env.tmp "$ENV_USER"

    echo ""
    echo "================================================================="
    echo ""
    echo "  SUCCESS: \`$ENV_USER\` with provided input has been created."
    echo "  The \`$ENV_USER\` file contains user configuration and will not"
    echo "  be overriden during subsequent installs/upgrades."
    echo "  Edit only \`$ENV_USER\` if you would like to change InfiniMetrics configuration."
    echo "  Proceeding with installation, please wait ..."
    echo ""
    echo "=================================================================="
    echo ""
    sleep 12
fi
