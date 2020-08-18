#!/usr/bin/env bash
set -euo pipefail

#
# Takes a manifest file and commits it to the
# gitops repo.
#

[ -z $MANIFEST_FILE ] && { echo "ERROR: MANIFEST_FILE required"; }

cat $MANIFEST_FILE
