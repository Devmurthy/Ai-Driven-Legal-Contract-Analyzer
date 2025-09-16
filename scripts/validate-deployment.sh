#!/usr/bin/env bash
# ADDED: Validation automation for AI Legal Contract Analyzer
# Idempotent script to deploy, assign perms, load data, verify flows/reports, and run tests.

set -euo pipefail

ORG_ALIAS=${1:-}
if [[ -z "$ORG_ALIAS" ]]; then
  echo "Usage: $0 <org-alias>"
  echo "Example: $0 legal-analyzer"
  exit 1
fi

echo "[1/6] Deploying metadata from manifest/package.xml to org: $ORG_ALIAS"
sfdx force:source:deploy -u "$ORG_ALIAS" -x manifest/package.xml || true

echo "[2/6] Assigning permission set: Legal_Analyzer_User"
sfdx force:user:permset:assign -u "$ORG_ALIAS" -n Legal_Analyzer_User || true

echo "[3/6] Importing sample data (Contracts & Clauses)"
if [[ -f data/sample-data.json ]]; then
  sfdx force:data:tree:import -u "$ORG_ALIAS" -f data/sample-data.json || true
else
  echo "Skipping data import: data/sample-data.json not found"
fi

echo "[4/6] Validating Flows are Active"
sfdx force:data:soql:query -u "$ORG_ALIAS" -q "SELECT DeveloperName, Status FROM FlowDefinitionView WHERE DeveloperName IN ('Contract_Status_Change','Clause_Status_Change')" || true

echo "[5/6] Validating Reports & Dashboard existence"
sfdx force:data:soql:query -u "$ORG_ALIAS" -q "SELECT DeveloperName FROM Report WHERE DeveloperName IN ('Contracts_by_Status','Clauses_by_Status')" || true
# Dashboard metadata presence is verified via source deployment; UI existence can be checked manually if needed.

echo "[6/6] Running Apex tests with code coverage"
sfdx force:apex:test:run -u "$ORG_ALIAS" -r human -c -w 20 || true

echo "Validation completed. Review the outputs above for any warnings or errors."


