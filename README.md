# Terraform Drift Detection Project

This project automatically detects and reports infrastructure drift using Terraform, Jenkins, and AWS CloudWatch.

## Components:
1. Terraform configuration for AWS resources
2. Jenkins pipeline for automation
3. Drift detection script
4. CloudWatch dashboard for monitoring

## Setup:
1. Configure AWS credentials in Jenkins
2. Set up Jenkins with necessary plugins
3. Create a new Jenkins pipeline using the provided Jenkinsfile
4. Ensure Terraform is installed on the Jenkins server

## Usage:
- The Jenkins pipeline runs periodically to check for drift
- Drift status is reported to CloudWatch
- View the CloudWatch dashboard for drift status visualization

## Monitoring:
- Check the CloudWatch dashboard for drift status
- Review Jenkins console output for detailed information