terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "my-sns" {
  source           = "./modules/sns"
  endpoint_arn_all = module.my-sqs-all.source_arn
  endpoint_arn_one = module.my-sqs-one.source_arn
}

module "my-sqs-all" {
  source        = "./modules/sqs"
  name          = "all"
  sns_topic_arn = module.my-sns.topic_arn
}

module "my-sqs-one" {
  source        = "./modules/sqs"
  name          = "one"
  sns_topic_arn = module.my-sns.topic_arn
}

module "lambda_role" {
  source = "./modules/lambda_role"
}

module "my-lambda-all" {
  source           = "./modules/lambda"
  name             = "LambdaAll"
  event_source_arn = module.my-sqs-all.source_arn
  role_arn         = module.lambda_role.role_arn
}

module "my-lambda-one" {
  source           = "./modules/lambda"
  name             = "LambdaOne"
  event_source_arn = module.my-sqs-one.source_arn
  role_arn         = module.lambda_role.role_arn
}
