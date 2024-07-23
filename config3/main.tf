provider "aws" {
  region = var.aws_region
}

resource "aws_cloudwatch_log_group" "test_log_group" {
  name = "test-drift-log-group-${random_string.log_group_suffix.result}"
  retention_in_days = 1  # Minimize storage to avoid potential costs

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "random_string" "log_group_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_cloudwatch_log_group" "drift_logs" {
  name = "/terraform/drift-detector-cloudwatch"
}