#!/bin/bash

CONFIGS=("config1" "config2" "config3")

for CONFIG in "${CONFIGS[@]}"
do
    cd "$CONFIG"
    
    PLAN_OUTPUT=$(terraform plan -detailed-exitcode 2>&1)
    EXITCODE=$?
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    publish_metric() {
        aws cloudwatch put-metric-data \
            --region us-east-2 \
            --namespace "TerraformDriftDetector" \
            --metric-name "DriftStatus" \
            --value "$1" \
            --timestamp "$TIMESTAMP" \
            --dimensions Resource=S3Bucket,Configuration="$CONFIG"
    }

    ensure_log_stream_exists() {
    aws logs describe-log-streams \
        --log-group-name "/terraform/drift-detector" \
        --log-stream-name-prefix "drift-logs" \
        --query 'logStreams[0].logStreamName' \
        --output text | grep -q "drift-logs" || \
    aws logs create-log-stream \
        --log-group-name "/terraform/drift-detector" \
        --log-stream-name "drift-logs"
}

    log_drift_status() {
        local message=$1
        ensure_log_stream_exists
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
    fi

    cd ..
done