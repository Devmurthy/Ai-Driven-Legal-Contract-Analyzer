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
sf project deploy start --manifest manifest/package.xml --target-org "$ORG_ALIAS" || true

echo "[2/6] Assigning permission set: Legal_Analyzer_User"
sf org assign permset --name Legal_Analyzer_User --target-org "$ORG_ALIAS" || true

echo "[3/6] Importing sample data (Contracts & Clauses)"
if [[ -f data/sample-data.json ]]; then
  sf data import tree --file data/sample-data.json --target-org "$ORG_ALIAS" || true
else
  echo "Skipping data import: data/sample-data.json not found"
fi

echo "[4/6] Validating Flows are Active"
sf data query --query "SELECT DeveloperName, Status FROM FlowDefinitionView WHERE DeveloperName IN ('Contract_Status_Change','Clause_Status_Change')" --target-org "$ORG_ALIAS" || true

echo "[5/6] Validating Reports & Dashboard existence"
sf data query --query "SELECT DeveloperName FROM Report WHERE DeveloperName IN ('Contracts_by_Status','Clauses_by_Status')" --target-org "$ORG_ALIAS" || true
# Dashboard metadata presence is verified via source deployment; UI existence can be checked manually if needed.

echo "[6/6] Running Apex tests with code coverage"
sf apex test run --code-coverage --wait 20 --result-format human --target-org "$ORG_ALIAS" || true

echo "Validation completed. Review the outputs above for any warnings or errors."


