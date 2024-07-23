resource "aws_cloudwatch_dashboard" "drift_dashboard" {
  dashboard_name = "TerraformDriftDashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 24
        height = 6
        properties = {
          metrics = [
        ["TerraformDriftDetector", "DriftStatus", "Configuration", "config1"],
        ["TerraformDriftDetector", "DriftStatus", "Configuration", "config2"],
        ["TerraformDriftDetector", "DriftStatus", "Configuration", "config3"]
      ]
          view    = "timeSeries"
          stacked = false
          region  = "us-east-2"
          title   = "Terraform Drift Status by Configuration"
          period  = 300
        }
      }
    ]
  })
}