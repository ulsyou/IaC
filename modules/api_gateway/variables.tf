variable "api_name" {
  type        = string
  default     = "API"
}

variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
}

variable "user_lambda_arn" {
  type        = string
}

variable "article_lambda_arn" {
  type        = string
}

variable "comment_lambda_arn" {
  type        = string
}
