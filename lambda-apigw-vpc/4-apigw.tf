
module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 2.2.2"

  name                   = "apigw-${random_string.suffix.result}"
  description            = "API GW to Lambda function"
  protocol_type          = "HTTP"
  create_api_domain_name = false
  route_key              = "GET /${var.api_path}"
  target                 = module.lambda_function.lambda_function_arn

  create_default_stage = false

  tags = {
    Name = "http-apigateway-${random_string.suffix.result}"
  }
}

output "api_url" {
  value       = "${module.api_gateway.apigatewayv2_api_api_endpoint}/${var.api_path}"
  description = "The API endpoint to access the REST API"
}