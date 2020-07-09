#!/usr/bin/env bash
set -euo pipefail

#
# Builds the Slack Server API, builds a Docker image
# to host the API, and pushes it to GCP Registry.
#

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

IMAGE_REPO="orbiter-slack-api"
IMAGE_TAG="$("${ORBITER}"/ci/get-repo-id.sh ${IMAGE_REPO})"
cp "${SLACK_SERVER}"/ci/Dockerfile .
docker build . --tag "${IMAGE_REPO}:${IMAGE_TAG}"

echo "--- Push Image to GCR"
"${ORBITER}"/ci/docker-push-gcr.sh orbiter-279306 "${IMAGE_REPO}:${IMAGE_TAG}"
