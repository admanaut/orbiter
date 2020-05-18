#!/usr/bin/env bash
set -euo pipefail

#
# Uses Heroku's HTTP API to release an app from a docker image id.
#
# Note: HEROKU_API_TOKEN env needs to be in scope.
#

[ "$#" -lt 2 ] && { echo "ERROR: please provide an app name and an image id"; exit 1; }

APP_NAME="$1"
IMAGE_ID="$2"

curl -X PATCH https://api.heroku.com/apps/"${APP_NAME}"/formation \
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
