#!/bin/bash

CONFIG=$1
ALERT_EMAIL=$2
WORKSPACE=${WORKSPACE:-$(pwd)}

# Change to the correct directory
cd "${WORKSPACE}/${CONFIG}"

PLAN_OUTPUT=$(terraform plan -var="alert_email=${ALERT_EMAIL}" -detailed-exitcode 2>&1)
EXITCODE=$?
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

publish_metric() {
    aws cloudwatch put-metric-data \
    --region us-east-2 \
    --namespace "TerraformDriftDetector" \
    --metric-name "DriftStatus" \
    --value "$1" \
    --timestamp "$TIMESTAMP" \
    --dimensions Configuration="$CONFIG"
}

log_drift_status() {
    local message=$1
    aws logs put-log-events \
    --log-group-name "/terraform/drift-detector" \
    --log-stream-name "drift-logs" \
    --log-events timestamp=$(date +%s000),message="$message"
}

if [ $EXITCODE -eq 0 ]; then
    echo "No changes detected in $CONFIG. Infrastructure is up-to-date."
    publish_metric 0
    log_drift_status "No drift detected in $CONFIG at $TIMESTAMP"
elif [ $EXITCODE -eq 2 ]; then
    echo "Changes detected in $CONFIG:"
    echo "$PLAN_OUTPUT"
    publish_metric 1
    log_drift_status "Drift detected in $CONFIG at $TIMESTAMP"
else
    echo "Error running terraform plan in $CONFIG:"
    echo "$PLAN_OUTPUT"
    log_drift_status "Error detecting drift in $CONFIG at $TIMESTAMP"
    publish_metric 1
fi