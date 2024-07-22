#!/bin/bash

# Run terraform plan and capture the output
PLAN_OUTPUT=$(terraform plan -detailed-exitcode 2>&1)
EXITCODE=$?

# Get the current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Function to publish metric to CloudWatch
publish_metric() {
    local drift_status=$1
    aws cloudwatch put-metric-data \
      --region us-east-2 \
      --namespace "TerraformDriftDetector" \
      --metric-name "DriftStatus" \
      --value "$drift_status" \
      --timestamp "$TIMESTAMP" \
      --dimensions Resource=S3Bucket
}

# Function to ensure log stream exists
ensure_log_stream_exists() {
    aws logs describe-log-streams \
      --region us-east-2 \
      --log-group-name "/terraform/drift-detector" \
      --log-stream-name-prefix "drift-logs" \
      --query 'logStreams[0].logStreamName' \
      --output text | grep -q "drift-logs" || \
    aws logs create-log-stream \
      --region us-east-2 \
      --log-group-name "/terraform/drift-detector" \
      --log-stream-name "drift-logs"
}

# Function to log drift status to CloudWatch Logs
log_drift_status() {
    local message=$1
    ensure_log_stream_exists
    aws logs put-log-events \
      --region us-east-2 \
      --log-group-name "/terraform/drift-detector" \
      --log-stream-name "drift-logs" \
      --log-events timestamp=$(date +%s000),message="$message"
}

# Check the exit code to determine if there's drift
if [ $EXITCODE -eq 0 ]; then
    echo "No changes detected. Infrastructure is up-to-date."
    publish_metric 0
    log_drift_status "No drift detected at $TIMESTAMP"
elif [ $EXITCODE -eq 2 ]; then
    echo "Changes detected:"
    echo "$PLAN_OUTPUT"
    publish_metric 1
    log_drift_status "Drift detected at $TIMESTAMP"
else
    echo "Error running terraform plan:"
    echo "$PLAN_OUTPUT"
    log_drift_status "Error detecting drift at $TIMESTAMP"
    exit 1
fi