#!/usr/bin/env bash
set -euo pipefail

#
# Logs in to the remote docker repository.
#

[ "$#" -lt 2 ] && { echo "ERROR: please provide a 'repo-name' and an 'image-name'"; exit 1; }

REPO_NAME="$1"
IMAGE_TAG="$2"

DOCKER_REGISTRY="registry.heroku.com"
DOCKER_REPOSITORY="${DOCKER_REGISTRY}/${REPO_NAME}"

docker login \
       --username="${DOCKER_REGISTRY_USERNAME}" \
       --password="${DOCKER_REGISTRY_PASSWORD}" \
       "${DOCKER_REGISTRY}"

docker tag "${IMAGE_TAG}" "${DOCKER_REPOSITORY}/${IMAGE_TAG}"
docker push "${DOCKER_REPOSITORY}/${IMAGE_TAG}"
