variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}

variable "alert_email" {
  description = "Email address for drift alerts"
  type        = string
}