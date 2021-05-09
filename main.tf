provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

module "lambda" {
  source = "./modules/lambda"
}

module "apigateway" {
  source = "./modules/apigateway"
}
