# Terraform Drift Detection Project

## Overview

This project implements an automated system to detect and report infrastructure drift using Terraform, Jenkins, and AWS CloudWatch. It helps maintain infrastructure consistency by identifying discrepancies between the defined Terraform state and the actual state of AWS resources.

## Components

- **Terraform**: Manages AWS infrastructure
- **Jenkins**: Automates the drift detection process
- **AWS CloudWatch**: Monitors and visualizes drift status
- **Bash Script**: Executes drift detection and reporting

## Prerequisites

- AWS account with appropriate permissions
- Docker installed on your local machine
- Git

## Setup Instructions

1. **Clone the Repository**
   ```
   git clone https://github.com/Nandini2510/terraform-drift-dashboard.git
   cd terraform-drift-dashboard
   ```

2. **Set Up AWS Credentials**
   - Create an IAM user in AWS with necessary permissions
   - Note down the Access Key ID and Secret Access Key

3. **Configure Jenkins (Docker)**
   - Build the custom Jenkins Docker image:
     ```
     docker build -t jenkins-terraform-aws:latest .
     ```
   - Run Jenkins container:
     ```
     docker run -d -p 8080:8080 -p 50000:50000 -v jenkins:/var/jenkins_home --name jenkins-terraform jenkins-terraform-aws:latest
     ```
   - Access Jenkins at `http://localhost:8080`

4. **Configure Jenkins Pipeline**
   - Create a new pipeline job in Jenkins
   - Use the Jenkinsfile from this repository as the pipeline script

5. **Set Up AWS Credentials in Jenkins**
   - Go to 'Manage Jenkins' > 'Manage Credentials'
   - Add new credentials of type 'Secret text' for AWS Access Key ID and Secret Access Key

6. **Configure Terraform**
   - Ensure your `main.tf` file is properly configured with your desired AWS resources

7. **Set Up CloudWatch Dashboard**
   - The Terraform configuration includes a CloudWatch dashboard setup

## Usage

1. **Run the Jenkins Pipeline**
   - Manually trigger the pipeline or set up periodic builds

2. **Monitor Drift**
   - Check the CloudWatch dashboard for drift status
   - Review Jenkins console output for detailed information

3. **Introducing Test Drift**
   - Manually modify a resource in AWS (e.g., add a tag to the S3 bucket)
   - Run the Jenkins pipeline to detect this drift


