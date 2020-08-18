#!/usr/bin/env bash
set -euo pipefail

#
# Configure kubectl for gke account
#

[ "$#" -lt 3 ] && { echo "ERROR: please provide 'cluster name', 'zone name' and a 'project name'"; exit 1; }

CLUSTER="$1"
ZONE="$2"
PROJECT="$3"

echo "--- Activate account"

gcloud auth activate-service-account "${GCLOUD_GKE_ACCOUNT}" --key-file="${GCLOUD_GKE_KEY_FILE}"
echo "--- Init kubectl"

# configure kubectl for this cluster
gcloud container clusters get-credentials "${CLUSTER}" --zone "${ZONE}" --project "${PROJECT}"
