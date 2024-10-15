output "api_gateway_id" {
  value = module.api_gateway.api_id
}

output "dynamodb_table_names" {
  value = {
    users    = module.dynamodb.users_table_name
    articles = module.dynamodb.articles_table_name
    comments = module.dynamodb.comments_table_name
  }
}

output "cloudfront_distribution_domain_name" {
  value = module.cloudfront.cloudfront_distribution_domain_name
}

output "cloudfront_distribution_id" {
  value = module.cloudfront.cloudfront_distribution_id
}
