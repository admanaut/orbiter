#!/usr/bin/env bash
set -euo pipefail

#
# Deploy and release the image to GKE
#

[ -z $CONTAINER_IMAGE ] && { echo "ERROR: CONTAINER_IMAGE required"; }

APOD="${ORBITER}"/web/apod
cd "${APOD}"

echo "--- Release the app"

gcloud auth activate-service-account "${GCLOUD_GCR_ACCOUNT}" --key-file="${GCLOUD_GCR_KEY_FILE}"

# configure kubectl for this cluster
gcloud container clusters get-credentials orbiter-gke-clustes --zone europe-west2-c --project orbiter-279306

kubectl apply -f "${APOD}"/k8s/deployment.yaml -f "${APOD}"/k8s/service.yaml
