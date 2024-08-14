#!/usr/bin/env bash
set -e

verify_image() {
    docker image inspect "$1" >/dev/null 2>&1; 
}

OFFLINE_TAR_ARTIFACT="./docker/offline/images.tar.gz"

# Verify minimum docker requirements
source "./install/check-min-req.sh"

# Source the images from variables
. .env

echo "INFO: Images to be loaded:"
echo
echo "CLICKHOUSE_IMAGE = ${CLICKHOUSE_IMAGE}"
echo "POSTGRES_IMAGE = ${CLICKHOUSE_IMAGE}"
echo "NGINX_IMAGE = ${NGINX_IMAGE}"
echo "INFINIMETRICS_IMAGE = ${INFINIMETRICS_IMAGE}"
echo

echo "INFO: starting loading..."

docker load < $OFFLINE_TAR_ARTIFACT

echo "INFO: Verifying loaded images"

if ! verify_image "$CLICKHOUSE_IMAGE"; then
    echo "$CLICKHOUSE_IMAGE wasn't loaded"
    exit 1
fi

if ! verify_image "$POSTGRES_IMAGE"; then
    echo "$POSTGRES_IMAGE wasn't loaded"
    exit 1
fi

if ! verify_image "$NGINX_IMAGE"; then
    echo "$NGINX_IMAGE wasn't loaded"
    exit 1
fi

if ! verify_image "$INFINIMETRICS_IMAGE"; then
    echo "$INFINIMETRICS_IMAGE wasn't loaded"
    exit 1
fi

echo "INFO: Loaded all the images successfully"
