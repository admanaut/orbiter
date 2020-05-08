#!/usr/bin/env bash
set -euo pipefail

#
# Returns the sha of the HEAD suffixed by the given suffix
#

[ $# -eq 0 ] && { echo "ERROR: prefix is required"; exit 1; }
echo "`git rev-parse HEAD`-$1"
