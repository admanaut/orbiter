#!/usr/bin/env bash
set -euo pipefail

#
# Builds the APOD web app, builds an Nginx Docker image
# to serve the app, pushes it to GCP Registry
#

APOD="${ORBITER}"/web/apod
cd "${APOD}"

echo "--- Build App"

# install deps
yarn

# build app
yarn build:prod

echo "--- Build Image"

_build="${APOD}"/_build
rm -fr "${_build}"
mkdir -p "${_build}"

mv dist "${_build}/"
cd "${_build}"

IMAGE_TAG="$("${ORBITER}"/ci/get-repo-id.sh orgiter-web-apod)"
cp "${APOD}"/ci/Dockerfile .
cp "${APOD}"/ci/nginx.tmpl .
docker build . --tag "${IMAGE_TAG}"

echo "--- Push Image to GCR"
"${ORBITER}"/ci/docker-push-gcr.sh orbiter-279306 "${IMAGE_TAG}"
