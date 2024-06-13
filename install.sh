#!/usr/bin/env bash
set -eE

INSTALLED_VERSION=""
BASEDIR=$(dirname "$0")

source "$BASEDIR"/install/cli.sh
source "$BASEDIR"/install/check-min-req.sh
source "$BASEDIR"/install/init-data.sh
# Load the .env data
source "$BASEDIR"/.env

dc="docker compose --env-file .env --env-file $ENV_USER"

catch_dc_errors() {
    echo ""
    echo "================================================================="
    echo ""
    echo "  An error during InfiniMetrics installation has occurred. "
    echo "  Please see an output of \`$dc logs\` "
    echo "  command."
    echo ""
    echo "================================================================="
    echo ""
}

# Pull images from dotenv file
echo "INFO: images in dotenv file"
echo "CLICKHOUSE_IMAGE: $CLICKHOUSE_IMAGE"
echo "POSTGRES_IMAGE: $POSTGRES_IMAGE"
echo "NGINX_IMAGE: $NGINX_IMAGE"
echo "INFINIMETRICS_IMAGE: $INFINIMETRICS_IMAGE"
echo ""

declare -a images=("$CLICKHOUSE_IMAGE" "$POSTGRES_IMAGE" "$NGINX_IMAGE" "$INFINIMETRICS_IMAGE")

for img in "${images[@]}"
do
  if [ -z "$(docker images -q $img 2> /dev/null)" ]; then
    echo "INFO: Image $img is missing, pulling..."
    docker image pull $img
  else
    echo "INFO: Image $img existing, skipping pulling."
  fi
done


# turn everything off
echo "INFO: Stopping containers ..."
$dc down --remove-orphans --rmi local --timeout 120

trap 'catch_dc_errors' ERR

# build local docker images
echo "INFO: Building images ..."
$dc build postgres
echo "INFO: Docker images built"

if [ ! "$SKIP_INIT" == "1" ]; then
    echo "INFO: Starting web container to run database migrations..."
    set -x
    $dc run --rm web infinimetrics setup
    INSTALLED_VERSION=$($dc run --rm web infinimetrics --version)
    set +x
fi

if [ "$START_CONTAINERS" == "1" ]; then
    # start all the other services
    echo "INFO: Starting all services inside the compose..."
    $dc up -d --wait
else
    echo ""
    echo "================================================================="
    echo ""
    echo "  SUCCESS: InfiniMetrics installation has been completed."
    echo "  InfiniMetrics installed version is $INSTALLED_VERSION"
    echo "  Run the following command to get InfiniMetrics running:"
    echo ""
    echo "  $dc up -d"
    echo ""
    echo "=================================================================="
    echo ""
fi
