provider "aws" {
  region = var.aws_region
}

resource "aws_sns_topic" "test_topic" {
  name = "test-drift-topic-${random_string.topic_suffix.result}"
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "random_string" "topic_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_cloudwatch_log_group" "drift_logs" {
  name = "/terraform/drift-detector-sns"
}