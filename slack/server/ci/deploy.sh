#!/usr/bin/env bash
set -euo pipefail

#
# Builds the Slack Server API, builds a Docker image
# to host the API, pushes it to the Heroku Registry and
# releases the API on Heroku via the API.
#

DOCKER_REGISTRY="registry.heroku.com"
DOCKER_REPOSITORY="${DOCKER_REGISTRY}/orbiter-slack-api"

SLACK_SERVER="${ORBITER}"/slack/server
cd "${SLACK_SERVER}"

echo "--- Build the Server"

lein uberjar

echo "--- Build the Image"

_build="${SLACK_SERVER}"/_build
rm -fr "${_build}"
mkdir -p "${_build}"

mv "${SLACK_SERVER}"/target/uberjar/orbiter-slack-server-0.1.0-SNAPSHOT-standalone.jar "${_build}"/orbiter-slack-server.jar
cd "${_build}"

IMAGE_TAG="$("${ORBITER}"/ci/get-repo-id.sh orbiter-slack-api)"
cp "${SLACK_SERVER}"/ci/Dockerfile .
docker build . --tag "${IMAGE_TAG}"

echo "--- Push the Image"

"${ORBITER}"/ci/docker-login.sh

docker tag "${IMAGE_TAG}" "${DOCKER_REPOSITORY}/${IMAGE_TAG}"
docker push "${DOCKER_REPOSITORY}/${IMAGE_TAG}"

echo "--- Release the Image"

IMAGE_ID="$(docker inspect "${IMAGE_TAG}" --format={{.Id}})"
echo "${IMAGE_ID}"

"${ORBITER}"/ci/heroku-release.sh orbiter-slack-api "${IMAGE_ID}"
