#!/bin/bash

CONFIGS=("config1" "config2" "config3")
SNS_TOPIC_ARN="arn:aws:sns:us-east-2:211125520464:drift-alerts-log-qkvugovd"  # Replace with your actual SNS topic ARN

for CONFIG in "${CONFIGS[@]}"
do
    cd "$CONFIG"
    PLAN_OUTPUT=$(terraform plan -var="alert_email=ynandini0625@gmail.com" -detailed-exitcode 2>&1)
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

    send_sns_alert() {
        local message=$1
        aws sns publish \
        --topic-arn "$SNS_TOPIC_ARN" \
        --message "$message"
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
        send_sns_alert "Drift detected in $CONFIG at $TIMESTAMP. Please check the CloudWatch logs for details."
    else
        echo "Error running terraform plan in $CONFIG:"
        echo "$PLAN_OUTPUT"
        log_drift_status "Error detecting drift in $CONFIG at $TIMESTAMP"
        send_sns_alert "Error detecting drift in $CONFIG at $TIMESTAMP. Please check the CloudWatch logs for details."
    fi

    cd ..
done