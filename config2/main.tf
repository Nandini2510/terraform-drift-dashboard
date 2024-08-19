provider "aws" {
  region = var.aws_region
}

resource "aws_cloudwatch_log_group" "drift_logs" {
  name = "/terraform/drift-detector-sns"
}

resource "aws_sns_topic" "test_topic" {
  name = "test-drift-topic-oeefebvo"
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# output "sns_topic_arn" {
#   value = aws_sns_topic.drift_alerts.arn
# }

# resource "aws_sns_topic" "drift_alerts" {
#   name = "drift-alerts-sns-oeefebvo"
# }

# resource "aws_sns_topic_subscription" "email" {
#   topic_arn = aws_sns_topic.drift_alerts.arn
#   protocol  = "email"
#   endpoint  = var.alert_email
# }


resource "random_string" "topic_suffix" {
  length  = 8
  special = false
  upper   = false
}