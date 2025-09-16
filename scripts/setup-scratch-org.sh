#!/usr/bin/env bash
# ADDED: Script to create and prepare a scratch org for demo

set -euo pipefail

DEV_HUB=${1:-}
ALIAS=${2:-legal-analyzer-scratch}

if [[ -z "$DEV_HUB" ]]; then
  echo "Usage: $0 <dev-hub-alias> [scratch-org-alias]"
  exit 1
fi

echo "Auth check for Dev Hub: $DEV_HUB"
sfdx force:org:list | grep "$DEV_HUB" || echo "Ensure Dev Hub is authenticated."

echo "Creating scratch org: $ALIAS"
sfdx force:org:create -v "$DEV_HUB" -s -f config/project-scratch-def.json -a "$ALIAS" -d 7

echo "Pushing metadata"
sfdx force:source:push -u "$ALIAS"

echo "Assigning permission set"
sfdx force:user:permset:assign -u "$ALIAS" -n Legal_Analyzer_User || true

echo "Loading sample data"
if [[ -f data/sample-data.json ]]; then
  sfdx force:data:tree:import -u "$ALIAS" -f data/sample-data.json || true
fi

echo "Opening org"
sfdx force:org:open -u "$ALIAS"


