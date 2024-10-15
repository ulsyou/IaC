provider "aws" {
  region  = var.region
}

module "vpc" {
  source     = "./modules/vpc"
}

module "ec2" {
  source = "./modules/ec2"

  vpc_id             = module.vpc.public_vpc_id
  public_subnet_id   = module.vpc.public_subnet_1_id
  private_subnet_id  = module.vpc.private_subnet_ids[0]
}

module "s3" {
  source = "./modules/s3"
}

module "cloudfront" {
  source = "./modules/cloudfront"
  public_bucket_id                = module.s3.public_bucket_id
  public_bucket_arn               = module.s3.public_bucket_arn
  public_bucket_website_endpoint  = module.s3.public_bucket_website_endpoint
}

module "cloudwatch" {
  source = "./modules/cloudwatch"

  user_lambda_function_name   = module.lambda.user_lambda_function_name
  article_lambda_function_name = module.lambda.article_lambda_function_name
  comment_lambda_function_name = module.lambda.comment_lambda_function_name
}


module "api_gateway" {
  source              = "./modules/api_gateway"
  user_lambda_arn     = module.lambda.user_lambda_arn
  article_lambda_arn  = module.lambda.article_lambda_arn
  comment_lambda_arn  = module.lambda.comment_lambda_arn
}

module "lambda" {
  source                    = "./modules/lambda"
  private_vpc_id            = module.vpc.private_vpc_id 
  private_subnet_ids        = module.vpc.private_subnet_ids
  security_group_id         = module.ec2.lambda_sg_id
  user_lambda_function_name = "user_lambda_function"
  article_lambda_function_name = "article_lambda_function"
  comment_lambda_function_name = "comment_lambda_function"
  api_gateway_execution_arn = module.api_gateway.execution_arn
  api_gateway_id            = module.api_gateway.api_id
  api_execution_arn         = module.api_gateway.execution_arn
  users_table_name          = module.dynamodb.users_table_name
  articles_table_name       = module.dynamodb.articles_table_name
  comments_table_name       = module.dynamodb.comments_table_name
} 

module "dynamodb" {
  source = "./modules/dynamodb"
}