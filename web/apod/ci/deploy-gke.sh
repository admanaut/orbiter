#!/usr/bin/env bash
set -euo pipefail

#
# Deploy and release GKE manifests
#

[ -z $CONTAINER_IMAGE ] && { echo "ERROR: CONTAINER_IMAGE required"; }

APOD="${ORBITER}"/web/apod
cd "${APOD}"

echo "--- Init Kubectl"

gcloud auth activate-service-account "${GCLOUD_GKE_ACCOUNT}" --key-file="${GCLOUD_GKE_KEY_FILE}"

# configure kubectl for this cluster
gcloud container clusters get-credentials orbiter-gke-clustes --zone europe-west2-c --project orbiter-279306

echo "--- Patch manifests"

cd "${APOD}"/k8s/

# patch kustomization file with latest image tag
cat <<EOF >> kustomization.yaml
images:
- name: web-apod-image
  newName: $CONTAINER_IMAGE
EOF

echo "--- Build and apply manifests"

kubectl kustomize . | kubectl apply -f -
