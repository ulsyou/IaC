resource "aws_cloudwatch_log_group" "IaC" {
  name = "IaC-log-group"
}

resource "aws_cloudwatch_metric_alarm" "user_errors_alarm" {
  alarm_name          = "user-errors-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    FunctionName = var.user_lambda_function_name
  }

  alarm_description = "Alarm when user lambda function has errors"
  actions_enabled   = true
}

resource "aws_cloudwatch_metric_alarm" "article_errors_alarm" {
  alarm_name          = "article-errors-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    FunctionName = var.article_lambda_function_name
  }

  alarm_description = "Alarm when article lambda function has errors"
  actions_enabled   = true
}

resource "aws_cloudwatch_metric_alarm" "comment_errors_alarm" {
  alarm_name          = "comment-errors-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  dimensions = {
    FunctionName = var.comment_lambda_function_name
  }

  alarm_description = "Alarm when comment lambda function has errors"
  actions_enabled   = true
}

resource "aws_cloudwatch_metric_alarm" "user_throttles_alarm" {
  alarm_name          = "user-throttles-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 0

  dimensions = {
    FunctionName = var.user_lambda_function_name
  }

  alarm_description = "Alarm when user lambda function is throttled"
  actions_enabled   = true
}

resource "aws_cloudwatch_metric_alarm" "article_throttles_alarm" {
  alarm_name          = "article-throttles-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 0

  dimensions = {
    FunctionName = var.article_lambda_function_name
  }

  alarm_description = "Alarm when article lambda function is throttled"
  actions_enabled   = true
}

resource "aws_cloudwatch_metric_alarm" "comment_throttles_alarm" {
  alarm_name          = "comment-throttles-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Throttles"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Sum"
  threshold           = 0

  dimensions = {
    FunctionName = var.comment_lambda_function_name
  }

  alarm_description = "Alarm when comment lambda function is throttled"
  actions_enabled   = true
}
