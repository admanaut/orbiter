#!/usr/bin/env bash
set -euo pipefail

#
# Logs in to the remote docker repository.
#

docker login \
       --username="${DOCKER_REGISTRY_USERNAME}" \
       --password="${DOCKER_REGISTRY_PASSWORD}" \
       "${DOCKER_REGISTRY}"
