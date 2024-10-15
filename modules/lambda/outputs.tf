output "user_lambda_function_name" {
  value = aws_lambda_function.user.function_name
}

output "article_lambda_function_name" {
  value = aws_lambda_function.article.function_name
}

output "comment_lambda_function_name" {
  value = aws_lambda_function.comment.function_name
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "user_lambda_arn" {
  value = aws_lambda_function.user.arn
}

output "article_lambda_arn" {
  value = aws_lambda_function.article.arn
}

output "comment_lambda_arn" {
  value = aws_lambda_function.comment.arn
}