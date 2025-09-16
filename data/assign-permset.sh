#!/usr/bin/env bash
# ADDED: Helper script to assign Legal_Analyzer_User permission set to a user
# Usage: ./data/assign-permset.sh -u <username|alias> -t <target-username>

set -euo pipefail

ORG_ALIAS=""
TARGET_USER=""

while getopts u:t: flag; do
  case "${flag}" in
    u) ORG_ALIAS=${OPTARG};;
    t) TARGET_USER=${OPTARG};;
  esac
done

if [[ -z "$ORG_ALIAS" || -z "$TARGET_USER" ]]; then
  echo "Usage: $0 -u <org-alias> -t <target-username>"
  exit 1
fi

echo "Assigning Legal_Analyzer_User to $TARGET_USER on org $ORG_ALIAS ..."
sfdx force:user:permset:assign -u "$ORG_ALIAS" -n Legal_Analyzer_User -o "$TARGET_USER"
echo "Done."


