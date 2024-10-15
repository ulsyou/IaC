output "public_bucket_id" {
  value = aws_s3_bucket.public_bucket.id
}

output "public_bucket_arn" {
  value = aws_s3_bucket.public_bucket.arn
}

output "public_bucket_website_endpoint" {
  value = aws_s3_bucket_website_configuration.public_bucket.website_endpoint
}