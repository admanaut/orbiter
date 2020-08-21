#!/usr/bin/env bash
set -euo pipefail

#
# Deploy and release GKE manifests
#

[ -z $CONTAINER_IMAGE ] && { echo "ERROR: CONTAINER_IMAGE required"; }

[ "$#" -lt 2 ] && { echo "ERROR: please provide 'app-folder' and a 'manifest-name'"; exit 1; }

APP="$1"
MANIFEST="$2"

echo "--- Patch manifests"

cd "${APP}"/k8s/

# patch kustomization file with latest image tag
cat <<EOF >> kustomization.yaml
images:
- name: container-image
  newName: $CONTAINER_IMAGE
EOF

echo "--- Build manifests"

kubectl kustomize . > "${MANIFEST}"

if [ -n "$CI" ]; then
    echo "::set-env name=MANIFEST_FILE::${APP}/k8s/${MANIFEST}";
fi
