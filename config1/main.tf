provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "my-test-drift-bucket-${random_string.bucket_suffix.result}"
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_s3_bucket_ownership_controls" "test_bucket" {
  bucket = aws_s3_bucket.test_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "test_bucket" {
  bucket                  = aws_s3_bucket.test_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_cloudwatch_log_group" "drift_logs" {
  name = "/terraform/drift-detector-s3"
}