#!/usr/bin/env bash
# ADDED: Script to create an unlocked package and version; prints install URL

set -euo pipefail

DEV_HUB=${1:-}
if [[ -z "$DEV_HUB" ]]; then
  echo "Usage: $0 <dev-hub-alias>"
  exit 1
fi

PKG_NAME="AI Legal Contract Analyzer"

echo "Creating package (if not exists): $PKG_NAME"
sfdx force:package:create -v "$DEV_HUB" -n "$PKG_NAME" -t Unlocked -r force-app || true

echo "Creating package version..."
VER_JSON=$(sfdx force:package:version:create -v "$DEV_HUB" -p "$PKG_NAME" -x -w 60 -c -f config/project-scratch-def.json -v 1.0.0.NEXT -n "ver 1.0" -a latest -t DeprecateOnly -o json)
echo "$VER_JSON"
VERSION_ID=$(echo "$VER_JSON" | jq -r '.result.SubscriberPackageVersionId')
if [[ -z "$VERSION_ID" || "$VERSION_ID" == "null" ]]; then
  echo "Failed to get version id"; exit 1
fi

echo "Subscriber Package Version Id: $VERSION_ID"
echo "Installation URL: https://login.salesforce.com/packaging/installPackage.apexp?p0=$VERSION_ID"


