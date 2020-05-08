#!/usr/bin/env bash
set -euo pipefail

#
# Builds the APOD web App, builds an Nginx Docker image
# to serve the App and pushes it to the Registry.
#

DOCKER_REGISTRY="registry.heroku.com"
# DOCKER_REPOSITORY="orbiter-slack-api/web"
DOCKER_REPOSITORY="${DOCKER_REGISTRY}/orbiter-slack-api"

APOD="${ORBITER}"/web/apod
cd "${APOD}"

echo "--- Build the App"
# install deps
yarn

# build app
yarn build:prod

# ZIP_NAME=

echo "--- Build the Image"
_build="${APOD}"/_build
rm -fr "${_build}"
mkdir -p "${_build}"

mv dist "${_build}/"
cd "${_build}"

#IMAGE_TAG="orbiter-web-apod:latest"
IMAGE_TAG="$("${ORBITER}"/web/apod/ci/get-repo-id.sh orgiter-web-apod)"
cp "${APOD}"/ci/Dockerfile .
cp "${APOD}"/ci/nginx.tmpl .
docker build . --tag "${IMAGE_TAG}"

echo "--- Push the Image"
docker login \
       --username="${DOCKER_REGISTRY_USERNAME}" \
       --password="${DOCKER_REGISTRY_PASSWORD}" \
       "${DOCKER_REGISTRY}"

docker tag "${IMAGE_TAG}" "${DOCKER_REPOSITORY}/${IMAGE_TAG}"
docker push "${DOCKER_REPOSITORY}/${IMAGE_TAG}"

echo "--- Release the Image"

IMAGE_ID="$(docker inspect "${IMAGE_TAG}" --format={{.Id}})"
echo "${IMAGE_ID}"

curl -X PATCH https://api.heroku.com/apps/orbiter-slack-api/formation \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3.docker-releases" \
  -H "Authorization: Bearer ${HEROKU_API_TOKEN}" \
  -d '{
  "updates": [
    {
      "type": "web",
      "docker_image": "'"${IMAGE_ID}"'"
    }
  ]
}'
