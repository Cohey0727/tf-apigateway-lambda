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
