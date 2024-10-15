output "api_id" {
  value       = aws_api_gateway_rest_api.this.id
}

output "api_root_resource_id" {
  value       = aws_api_gateway_rest_api.this.root_resource_id
}

output "execution_arn" {
  value       = aws_api_gateway_rest_api.this.execution_arn
}

output "api_gateway_url" {
  value = "${aws_api_gateway_rest_api.this.execution_arn}/users"
}
