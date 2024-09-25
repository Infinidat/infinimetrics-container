#!/usr/bin/env bash
set -eE

echo "INFO: Checking minimum requirements ..."

MIN_DOCKER_VERSION='20.10.18'
MIN_COMPOSE_VERSION='2.17.0'
IMX_DEBUG="${IMX_DEBUG:-0}"

vercomp() {
    printf "%s\n%s" "$1" "$2" | sort --version-sort --check=quiet --reverse
    echo $?
}

DOCKER_VERSION=$(docker version --format '{{.Server.Version}}' || echo '')
if [[ -z "$DOCKER_VERSION" ]]; then
    echo "FAIL: Unable to get docker version, is the docker daemon running?"
    exit 1
fi

if [[ "$(vercomp ${DOCKER_VERSION//v/} $MIN_DOCKER_VERSION)" -eq 1 ]]; then
    echo "FAIL: The minimum supported docker version is $MIN_DOCKER_VERSION but found $DOCKER_VERSION"
    exit 1
fi
echo "INFO: Docker version is $DOCKER_VERSION"

DOCKER_ARCH=$(docker info --format '{{.Architecture}}')
if [[ ! "$IMX_DEBUG" = "1" && ! "$DOCKER_ARCH" = "x86_64" ]]; then
    echo "FAIL: Supported docker architecture is x86_64 but found $DOCKER_ARCH"
    exit 1
fi

COMPOSE_VERSION=$(docker compose version --short || echo '')
if [[ -z "$COMPOSE_VERSION" ]]; then
    echo "FAIL: Docker compose is required"
    exit 1
fi

if [[ "$(vercomp ${COMPOSE_VERSION//v/} $MIN_COMPOSE_VERSION)" -eq 1 ]]; then
    echo "FAIL: The minimum supported docker compose version is $MIN_COMPOSE_VERSION but found $COMPOSE_VERSION"
    exit 1
fi
echo "INFO: Found Docker Compose version $COMPOSE_VERSION"

