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


resource "aws_api_gateway_deployment" "rest_api" {
  stage_name  = "api"
  rest_api_id = module.apigateway.api_gateway_id
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "rest_api_invoke" {
  function_name = module.lambda.lambda_arn
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${module.apigateway.api_gateway_execution_arn}/*"
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = module.apigateway.api_gateway_id
  parent_id   = module.apigateway.api_gateway_root_resource_id
  path_part   = "hello"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = module.apigateway.api_gateway_id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "restapi_integration" {
  rest_api_id             = module.apigateway.api_gateway_id
  resource_id             = module.apigateway.api_gateway_root_resource_id
  uri                     = module.lambda.lambda_invoke_arn
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
}

# output "EndpointURL" {
#   value = aws_api_gateway_deployment.rest_api.invoke_url
# }

# output "RestAPIId" {
#   value = module.apigateway.api_gateway_id
# }
