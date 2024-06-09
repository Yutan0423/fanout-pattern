variable "name" {}
variable "sns_topic_arn" {}

resource "aws_sqs_queue" "my_queue" {
  name = var.name
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.my_queue.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "sqs:SendMessage",
        Resource  = aws_sqs_queue.my_queue.arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = var.sns_topic_arn
          }
        }
      }
    ]
  })
}

output "source_arn" {
  value = aws_sqs_queue.my_queue.arn
}

output "queue_id" {
  value = aws_sqs_queue.my_queue.id
}
