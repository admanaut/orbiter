#!/usr/bin/env bash
set -euo pipefail

#
# Deploy and release GKE manifests
#

[ -z $CONTAINER_IMAGE ] && { echo "ERROR: CONTAINER_IMAGE required"; }

APOD="${ORBITER}"/web/apod
cd "${APOD}"

echo "--- Patch manifests"

cd "${APOD}"/k8s/

# patch kustomization file with latest image tag
cat <<EOF >> kustomization.yaml
images:
- name: container-image
  newName: $CONTAINER_IMAGE
EOF

echo "--- Build manifests"

kubectl kustomize . > web-apod.yaml

if [ -n "$CI" ]; then
    echo "::set-env name=MANIFEST_FILE::${APOD}/k8s/web-apod.yaml";
fi
