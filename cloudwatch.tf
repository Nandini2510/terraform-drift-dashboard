resource "aws_cloudwatch_metric_alarm" "drift_alarm_config1" {
  alarm_name          = "drift-alarm-config1"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DriftStatus"
  namespace           = "TerraformDriftDetector"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors drift in config1"
  alarm_actions       = [aws_sns_topic.drift_alerts.arn]
  dimensions = {
    Configuration = "config1"
  }
}

resource "aws_cloudwatch_metric_alarm" "drift_alarm_config2" {
  alarm_name          = "drift-alarm-config2"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DriftStatus"
  namespace           = "TerraformDriftDetector"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors drift in config2"
  alarm_actions       = [aws_sns_topic.drift_alerts.arn]
  dimensions = {
    Configuration = "config2"
  }
}

resource "aws_cloudwatch_metric_alarm" "drift_alarm_config3" {
  alarm_name          = "drift-alarm-config3"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DriftStatus"
  namespace           = "TerraformDriftDetector"
  period              = "300"
  statistic           = "Maximum"
  threshold           = "0"
  alarm_description   = "This metric monitors drift in config3"
  alarm_actions       = [aws_sns_topic.drift_alerts.arn]
  dimensions = {
    Configuration = "config3"
  }
}