resource "aws_cloudwatch_metric_alarm" "drift_alarm_s3" {
  alarm_name          = "drift-alarm-s3"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DriftStatus"
  namespace           = "TerraformDriftDetector"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors drift in S3 configuration"
  alarm_actions       = [aws_sns_topic.drift_alerts.arn]
  dimensions = {
    Resource       = "S3Bucket"
    Configuration  = "config1"
  }
}

resource "aws_cloudwatch_metric_alarm" "drift_alarm_sns" {
  alarm_name          = "drift-alarm-sns"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DriftStatus"
  namespace           = "TerraformDriftDetector"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors drift in SNS configuration"
  alarm_actions       = [aws_sns_topic.drift_alerts.arn]
  dimensions = {
    Resource       = "SNSTopic"
    Configuration  = "config2"
  }
}

resource "aws_cloudwatch_metric_alarm" "drift_alarm_cloudwatch" {
  alarm_name          = "drift-alarm-cloudwatch"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DriftStatus"
  namespace           = "TerraformDriftDetector"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors drift in CloudWatch configuration"
  alarm_actions       = [aws_sns_topic.drift_alerts.arn]
  dimensions = {
    Resource       = "CloudWatchLogGroup"
    Configuration  = "config3"
  }
}