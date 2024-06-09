variable "endpoint_arn_all" {}
variable "endpoint_arn_one" {}

resource "aws_sns_topic" "my_topic" {
  name = "my-sns-topic"
}

resource "aws_sns_topic_subscription" "my_subscription_all" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "sqs"
  endpoint  = var.endpoint_arn_all
  filter_policy = jsonencode({
    color = ["all", "one"]
  })
}

resource "aws_sns_topic_subscription" "my_subscription" {
  topic_arn = aws_sns_topic.my_topic.arn
  protocol  = "sqs"
  endpoint  = var.endpoint_arn_one
  # filter_policy = jsonencode({
  #   color = ["one"]
  # })
}

output "topic_arn" {
  value = aws_sns_topic.my_topic.arn
}
