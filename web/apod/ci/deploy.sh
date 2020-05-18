#!/usr/bin/env bash
set -euo pipefail

#
# Builds the APOD web app, builds an Nginx Docker image
# to serve the app, pushes it to the Heroku Registry and
# releases the app on Heroku via the API.
#

DOCKER_REGISTRY="registry.heroku.com"
DOCKER_REPOSITORY="${DOCKER_REGISTRY}/orbiter-web-apod"

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

IMAGE_TAG="$("${ORBITER}"/ci/get-repo-id.sh orgiter-web-apod)"
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

curl -X PATCH https://api.heroku.com/apps/orbiter-web-apod/formation \
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
