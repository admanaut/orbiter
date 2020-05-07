#!/usr/bin/env bash
set -euo pipefail

#
# Builds the APOD web App, builds an Nginx Docker image
# to serve the App and pushes it to the Registry.
#

DOCKER_REGISTRY="registry.heroku.com"
DOCKER_REPOSITORY="orbiter-slack-api/web"

APOD="${ORBITER}"/web/apod
cd "${APOD}"

echo "--- Build the App"
# install deps
yarn

# build app
yarn build:prod

echo "--- Build the Image"
_build="${APOD}"/_build
rm -fr "${_build}"
mkdir -p "${_build}"

mv dist "${_build}/"
cd "${_build}"

# build image
IMAGE_TAG="orbiter-web-apod:latest"
cp "${APOD}"/ci/Dockerfile .
cp "${APOD}"/ci/nginx.tmpl .
docker build . --tag "${IMAGE_TAG}"

echo "--- Push the Image"
# docker push "$DOCKER_REPOSITORY:IMAGE_TAG"

heroku container:login
docker tag "${IMAGE_TAG}" "${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}"
docker push "${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}"

echo "--- Release the latest Image"
heroku container:release web
