#!/usr/bin/env bash
set -euo pipefail

#
# Builds the APOD web app, builds an Nginx Docker image
# to serve the app, pushes it to the Heroku Registry and
# releases the app on Heroku via the API.
#

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
"${ORBITER}"/ci/docker-push.sh orbiter-web-apod "${IMAGE_TAG}"

echo "--- Release the Image"
"${ORBITER}"/ci/heroku-release.sh orbiter-slack-api "${IMAGE_TAG}"
