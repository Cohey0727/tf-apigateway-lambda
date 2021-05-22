provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "lambda" {
  source   = "./modules/lambda"
  app_name = var.app_name
}

module "apigateway" {
  source   = "./modules/apigateway"
  app_name = var.app_name
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = module.apigateway.api_gateway_id
  resource_id             = module.apigateway.api_gateway_resource_id
  http_method             = "ANY"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = module.lambda.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = module.apigateway.api_gateway_id
  stage_name  = "test"
}
