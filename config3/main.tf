provider "aws" {
  region = var.aws_region
}

resource "aws_cloudwatch_log_group" "test_log_group" {
  name = "/terraform/drift-detector-cloudwatch"
  retention_in_days = 1  # Minimize storage to avoid potential costs

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_sns_topic" "drift_alerts" {
  name = "drift-alerts-log-qkvugovd"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.drift_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "random_string" "log_group_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_cloudwatch_log_group" "drift_logs" {
  name = "/terraform/drift-detector-cloudwatch"
}