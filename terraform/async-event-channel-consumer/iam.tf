resource "aws_iam_role_policy" "default" {
  name        = "auth-serv-assync-persistent"
  role        = module.lambda-consumer.role_id
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = var.queue_arn
      }, {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = var.dead_leaders_arn
      }
    ]
  })
}
