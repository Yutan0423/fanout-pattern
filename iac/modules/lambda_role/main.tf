data "aws_iam_policy" "lambda_execution" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

data "aws_iam_policy_document" "lambda_execution" {
  source_policy_documents = [data.aws_iam_policy.lambda_execution.policy]
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

module "lambda_execution_role" {
  source     = "../iam_role"
  name       = "lambda-execution"
  identifier = "lambda.amazonaws.com"
  policy     = data.aws_iam_policy.lambda_execution.policy
}

output "role_arn" {
  value = module.lambda_execution_role.iam_role_arn
}
