variable "private_subnet_ids" {
  type        = list(string)
}

variable "security_group_id" {
  type        = string
}

variable "user_lambda_function_name" {
  type        = string
}

variable "article_lambda_function_name" {
  type        = string
}

variable "comment_lambda_function_name" {
  type        = string
}

variable "api_gateway_execution_arn" {
  type        = string
}

variable "private_vpc_id" {
  type = string
}

variable "api_gateway_id" {
  type        = string
}

variable "api_execution_arn" {
  type        = string
}

variable "users_table_name" {
  type = string
}

variable "articles_table_name" {
  type = string
}

variable "comments_table_name" {
  type = string
}
