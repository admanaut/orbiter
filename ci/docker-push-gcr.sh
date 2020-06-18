#!/usr/bin/env bash
set -euo pipefail

#
# Logs in to the remote GCR registry and uploads the image
#
# Note: Container Registry API needs to be enabled first

[ "$#" -lt 2 ] && { echo "ERROR: please provide 'project-name' and an 'image-name'"; exit 1; }

PROJECT_NAME="$1"
IMAGE_TAG="$2"

DOCKER_REGISTRY="eu.gcr.io"
DOCKER_REPOSITORY="${DOCKER_REGISTRY}/${PROJECT_NAME}"

# GCR uses storage buckets to host images so make sure you grant
# this service account permissions to that bucket
gcloud auth activate-service-account "${GCLOUD_GCR_ACCOUNT}" --key-file="${GCLOUD_GCR_KEY_FILE}"

gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin "${DOCKER_REGISTRY}"

docker tag "${IMAGE_TAG}" "${DOCKER_REPOSITORY}/${IMAGE_TAG}"
docker push "${DOCKER_REPOSITORY}/${IMAGE_TAG}"
