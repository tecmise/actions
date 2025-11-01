resource "aws_sqs_queue" "queues" {
  for_each = local.queues
  name = each.value["fifo"] ? "${var.preffix}-entity-${each.value["name"]}.fifo" : "${var.preffix}-entity-${each.value["name"]}"
  fifo_queue = lookup(each.value, "fifo", false)
}

resource aws_sns_topic_subscription default {
  for_each = {
    for index, value in local.topics_to_subscribe : index => value
  }
  topic_arn = data.aws_sns_topic.topics[each.value["name"]].arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queues[each.value["queue"]].arn
  depends_on = [aws_sqs_queue.queues]
}


resource "aws_sqs_queue_redrive_policy" "default" {
  count = length(local.dead_letters_queue)
  queue_url = aws_sqs_queue.queues[local.dead_letters_queue[count.index]["name"]].url
  redrive_policy = jsonencode({
    deadLetterTargetArn = data.aws_sqs_queue.dead_letters[count.index].arn
    maxReceiveCount     = 5
  })
}

resource "aws_iam_policy" "default" {
  name        = "${var.application}-assync-event-channel-policy"
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
        Resource = flatten([
          for value in aws_sqs_queue.queues : value.arn
        ])
      }, {
        Effect = "Allow",
        Action = [
          "sqs:SendMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = flatten([
          for value in data.aws_sqs_queue.dead_letters : value.arn
        ])
      }
    ]
  })
}

resource "aws_sqs_queue_policy" "allow_sns_to_sqs" {
  for_each = local.queues
  queue_url = aws_sqs_queue.queues[each.key].id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = { Service = "sns.amazonaws.com" },
        Action = "sqs:SendMessage",
        Resource = aws_sqs_queue.queues[each.key].arn,
        Condition = {
          ArnEquals = {
            "aws:SourceArn" = [
              for name in lookup(each.value, "topics", []) :
              data.aws_sns_topic.topics[name].arn
            ]
          }
        }
      }
    ]
  })
}
