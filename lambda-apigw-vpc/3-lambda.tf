resource "aws_iam_policy" "lambda_policy" {
  name        = "LambdaS3ENIAccessPolicy"
  description = "IAM policy for Lambda to read S3 and create ENI"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${module.bucket.s3_bucket_arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:CreateTags"
        ]
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = module.lambda_function.lambda_role_name
}


module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  version = "5.3.0"

  function_name = "lambda-${random_string.suffix.result}"
  description   = "lambda function to read contents of a bucket file"
  handler       = "app.lambda_handler"
  runtime       = "python3.10"
  environment_variables = {
    S3_BUCKET_NAME    = module.bucket.s3_bucket_id
    S3_JSON_FILE_NAME = module.s3_object.s3_object_id
  }
  attach_cloudwatch_logs_policy = false
  create_role                   = true

  source_path = "${path.module}/app/"

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*/*"
    }
  }
  publish = true

  tags = {
    Name = "lambda-${random_string.suffix.result}"
  }
  vpc_security_group_ids = [module.security_group_lambda.security_group_id]
  vpc_subnet_ids         = module.vpc.intra_subnets
}

data "aws_iam_policy" "LambdaVPCAccess" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "sto-lambda-vpc-role-policy-attach" {
  role       = module.lambda_function.lambda_role_name
  policy_arn = data.aws_iam_policy.LambdaVPCAccess.arn
}

output "lambda_function_name" {
  value       = module.lambda_function.lambda_function_name
  description = "The lambda function name"
}