# Security Group for Lambda
resource "aws_security_group" "lambda_sg" {
  name        = "lambda-security-group"
  description = "Security group for Lambda functions"
  vpc_id      = var.private_vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda-security-group"
  }
}

data "aws_caller_identity" "current" {}

# Archive for Lambda Functions
data "archive_file" "user" {
  type        = "zip"
  source_dir  = "realworld_python-lambda-DDB/serverless/src"
  output_path = "lambda_functions/user.zip"
  depends_on  = [data.archive_file.dependencies]
}

data "archive_file" "article" {
  type        = "zip"
  source_dir  = "realworld_python-lambda-DDB/serverless/src"
  output_path = "lambda_functions/article.zip"
  depends_on  = [data.archive_file.dependencies]
}

data "archive_file" "comment" {
  type        = "zip"
  source_dir  = "realworld_python-lambda-DDB/serverless/src"
  output_path = "lambda_functions/comment.zip"
  depends_on  = [data.archive_file.dependencies]
}

data "archive_file" "dependencies" {
  type        = "zip"
  source_dir  = "realworld_python-lambda-DDB/serverless/commonPackages"
  output_path = "lambda_functions/dependencies.zip"
}

# Lambda Layer for Dependencies
resource "aws_lambda_layer_version" "dependencies" {
  layer_name          = "dependencies"
  compatible_runtimes = ["python3.9"]
  filename            = data.archive_file.dependencies.output_path
  source_code_hash    = data.archive_file.dependencies.output_base64sha256
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com",
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Lambda Functions
resource "aws_lambda_function" "user" {
  filename         = data.archive_file.user.output_path
  function_name    = "UserFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "user.create_user"
  runtime          = "python3.9"
  timeout          = 900

  layers           = [aws_lambda_layer_version.dependencies.arn]

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DYNAMODB_TABLE = var.users_table_name
    }
  }
}

resource "aws_lambda_function" "article" {
  filename         = data.archive_file.article.output_path
  function_name    = "ArticleFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "article.create_article"
  runtime          = "python3.9"
  timeout          = 900

  layers           = [aws_lambda_layer_version.dependencies.arn]

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DYNAMODB_TABLE = var.articles_table_name
    }
  }
}

resource "aws_lambda_function" "comment" {
  filename         = data.archive_file.comment.output_path
  function_name    = "CommentFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "comment.create"
  runtime          = "python3.9"
  timeout          = 900

  layers           = [aws_lambda_layer_version.dependencies.arn]

  vpc_config {
    subnet_ids         = var.private_subnet_ids
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  environment {
    variables = {
      DYNAMODB_TABLE = var.comments_table_name
    }
  }
}

# Lambda Permissions
resource "aws_lambda_permission" "user_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${var.api_gateway_execution_arn}/*/*"
}

resource "aws_lambda_permission" "article_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.article.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:ap-southeast-2:${data.aws_caller_identity.current.account_id}:${var.api_gateway_id}/*/*"
}

resource "aws_lambda_permission" "comment_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.comment.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:ap-southeast-2:${data.aws_caller_identity.current.account_id}:${var.api_gateway_id}/*/*"
}
