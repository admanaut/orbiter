#!/usr/bin/env bash
set -euo pipefail

#
# Deploy and release GKE manifests
#

[ -z $CONTAINER_IMAGE ] && { echo "ERROR: CONTAINER_IMAGE required"; }

SLACK_SERVER="${ORBITER}"/slack/server
cd "${SLACK_SERVER}"

echo "--- Patch manifests"

cd "${SLACK_SERVER}"/k8s/

# patch kustomization file with latest image tag
cat <<EOF >> kustomization.yaml
images:
- name: container-image
  newName: $CONTAINER_IMAGE
EOF

echo "--- Build manifests"

kubectl kustomize . > slack-api.yaml

if [ -n "$CI" ]; then
    echo "::set-env name=MANIFEST_FILE::${SLACK_SERVER}/k8s/slack-api.yaml";
fi
