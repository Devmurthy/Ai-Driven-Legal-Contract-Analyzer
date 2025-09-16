#!/usr/bin/env bash
# ADDED: Wrapper to import sample Contracts/Clauses data via data tree import

set -euo pipefail

ORG_ALIAS=${1:-}
if [[ -z "$ORG_ALIAS" ]]; then
  echo "Usage: $0 <org-alias>"
  exit 1
fi

if [[ ! -f data/sample-data.json ]]; then
  echo "data/sample-data.json not found"
  exit 1
fi

echo "Importing sample data into $ORG_ALIAS ..."
sfdx force:data:tree:import -u "$ORG_ALIAS" -f data/sample-data.json
echo "Done."


