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

    log_drift_status() {
        aws logs put-log-events \
            --region us-east-2 \
            --log-group-name "/terraform/drift-detector" \
            --log-stream-name "$CONFIG-drift-logs" \
            --log-events timestamp=$(date +%s000),message="$1"
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