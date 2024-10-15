output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.IaC.name
}

output "user_metric_alarm_id" {
  value = aws_cloudwatch_metric_alarm.user_errors_alarm.id
}

output "article_metric_alarm_id" {
  value = aws_cloudwatch_metric_alarm.article_errors_alarm.id
}

output "comment_metric_alarm_id" {
  value = aws_cloudwatch_metric_alarm.comment_errors_alarm.id
}

# Outputs cho các alarm throttles
output "user_throttle_alarm_id" {
  value = aws_cloudwatch_metric_alarm.user_throttles_alarm.id
}

output "article_throttle_alarm_id" {
  value = aws_cloudwatch_metric_alarm.article_throttles_alarm.id
}

output "comment_throttle_alarm_id" {
  value = aws_cloudwatch_metric_alarm.comment_throttles_alarm.id
}
