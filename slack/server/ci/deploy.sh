#!/usr/bin/env bash
set -euo pipefail

#
# Deploy and release GKE manifests
#

[ -z $CONTAINER_IMAGE ] && { echo "ERROR: CONTAINER_IMAGE required"; }

SLACK_SERVER="${ORBITER}"/slack/server
cd "${SLACK_SERVER}"

echo "--- Init Kubectl"

gcloud auth activate-service-account "${GCLOUD_GKE_ACCOUNT}" --key-file="${GCLOUD_GKE_KEY_FILE}"

# configure kubectl for this cluster
gcloud container clusters get-credentials orbiter-gke-clustes --zone europe-west2-c --project orbiter-279306

echo "--- Patch manifests"

cd "${SLACK_SERVER}"/k8s/

# patch kustomization file with latest image tag
cat <<EOF >> kustomization.yaml
images:
- name: slack-api-image
  newName: $CONTAINER_IMAGE
EOF

echo "--- Build and apply manifests"

kubectl kustomize . | kubectl apply -f -

# wait for the rollout to finish
kubectl rollout status deployment.apps/slack-api-deployment
