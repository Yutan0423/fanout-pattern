variable "name" {}
variable "event_source_arn" {}
variable "role_arn" {}

resource "aws_lambda_function" "my_lambda" {
  filename         = "${path.module}/../../../lambda/lambda_function_payload.zip"
  function_name    = var.name
  role             = var.role_arn
  handler          = "index.handler"
  runtime          = "provided.al2023"
  source_code_hash = filebase64sha256("${path.module}/../../../lambda/lambda_function_payload.zip")
}

resource "aws_lambda_event_source_mapping" "sqs_event" {
  event_source_arn = var.event_source_arn
  function_name    = aws_lambda_function.my_lambda.arn
  batch_size       = 10
  enabled          = true
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.my_lambda.function_name}"
  retention_in_days = 14 # ログの保持期間を設定
}
