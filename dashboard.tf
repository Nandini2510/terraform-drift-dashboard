resource "aws_cloudwatch_dashboard" "drift_dashboard" {
  dashboard_name = "TerraformDriftDashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            ["TerraformDriftDetector", "DriftStatus", "Resource", "S3Bucket"]
          ]
          view    = "timeSeries"
          stacked = false
          region  = "us-west-2"
          title   = "Terraform Drift Status"
          period  = 300
        }
      }
    ]
  })
}