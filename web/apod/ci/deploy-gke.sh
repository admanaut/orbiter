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

echo "--- Apply manifests"

cd "${APOD}"/k8s/

kustomize edit set image web-apod-image="$CONTAINER_IMAGE"

kustomize build . | kubectl apply -f -
