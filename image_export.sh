#!/usr/bin/env bash
set -e
# Source the images from variables
. .env

OFFLINE_TAR_ARTIFACT="./docker/offline/images.tar.gz"

echo "INFO: Images to be loaded:"
echo
echo "CLICKHOUSE_IMAGE = ${CLICKHOUSE_IMAGE}"
echo "POSTGRES_IMAGE = ${CLICKHOUSE_IMAGE}"
echo "NGINX_IMAGE = ${NGINX_IMAGE}"
echo "INFINIMETRICS_IMAGE = ${INFINIMETRICS_IMAGE}"
echo

echo "INFO: starting loading..."

docker pull --platform linux/amd64 "$INFINIMETRICS_IMAGE"
docker pull --platform linux/amd64 "$POSTGRES_IMAGE"
docker pull --platform linux/amd64 "$CLICKHOUSE_IMAGE"
docker pull --platform linux/amd64 "$NGINX_IMAGE"

docker save "$POSTGRES_IMAGE" "$CLICKHOUSE_IMAGE" "$NGINX_IMAGE" "$INFINIMETRICS_IMAGE" | gzip > $OFFLINE_TAR_ARTIFACT

echo "INFO: done."
