output "users_table_name" {
  value = aws_dynamodb_table.users.name
}

output "articles_table_name" {
  value = aws_dynamodb_table.articles.name
}

output "comments_table_name" {
  value = aws_dynamodb_table.comments.name
}
