provider "aws" {
  region = var.aws_region
}

resource "aws_sns_topic" "drift_alerts" {
  name = "central-drift-alerts-${random_string.sns_suffix.result}"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.drift_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "random_string" "sns_suffix" {
  length  = 8
  special = false
  upper   = false
}

output "sns_topic_arn" {
  value = aws_sns_topic.drift_alerts.arn
}