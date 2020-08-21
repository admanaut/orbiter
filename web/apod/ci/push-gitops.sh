#!/usr/bin/env bash
set -euo pipefail

#
# Takes a manifest file and pushes it to the
# gitops repo.
#

[ -z $MANIFEST_FILE ] && { echo "ERROR: MANIFEST_FILE required"; }
[ -z $GITOPS_REPO_ACCESS_KEY ] && { echo "ERROR: GITOPS_REPO_ACCESS_KEY required"; }

cd "${ORBITER}"
repo_path="orbiter-gitops"

echo "--- Prepare gitops repo"

git clone https://github.com/admanaut/orbiter-gitops.git "${repo_path}"

git -C "${repo_path}" --git-dir=.git fetch --prune origin

git -C "${repo_path}" --git-dir=.git clean -f

git -C "${repo_path}" --git-dir=.git checkout master

git -C "${repo_path}" --git-dir=.git clean -f

echo "--- Commit manifests"

MANIFEST="$(basename $MANIFEST_FILE)"
cat $MANIFEST_FILE > "${repo_path}"/workloads/"$MANIFEST"

git -C "${repo_path}" --git-dir=.git config user.name "${GITHUB_ACTOR}"
git -C "${repo_path}" --git-dir=.git config user.email "${GITHUB_ACTOR}@github.com"

COMMIT="$(git -C ${ORBITER} --git-dir=.git rev-parse HEAD)"
COMMIT_MSG="$(git -C ${ORBITER} --git-dir=.git show -s --format=%s ${COMMIT})"

git -C "${repo_path}" --git-dir=.git commit -a -m "[GA] $COMMIT $COMMIT_MSG"

echo "--- Push manifests"

#git -C "${repo_path}" --git-dir=.git remote set-url origin https://admanaut:"${GITOPS_REPO_ACCESS_KEY}"@github.com/orbiter-gitops.git

ORIGIN="https://admanaut:${GITOPS_REPO_ACCESS_KEY}@github.com/orbiter-gitops.git"

git -C "${repo_path}" --git-dir=.git push "${ORIGIN}" master
