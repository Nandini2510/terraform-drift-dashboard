variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "Test"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "TerraformDriftDetector"
}

variable "alert_email" {
  description = "Email address for drift alerts"
  type        = string
}