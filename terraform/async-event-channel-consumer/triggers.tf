resource "aws_lambda_permission" "default" {
  count = length(var.queue_urls)
  statement_id  = "sqs-event-trigger-${count.index}"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda-consumer.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = replace(tolist(var.queue_urls)[count.index], "https://sqs.${var.region}.amazonaws.com/${var.account_id}/", "arn:aws:sqs:${var.region}:${var.account_id}:")
}

resource "aws_lambda_event_source_mapping" "default" {
  count = length(var.queue_urls)
  event_source_arn = replace(tolist(var.queue_urls)[count.index], "https://sqs.${var.region}.amazonaws.com/${var.account_id}/", "arn:aws:sqs:${var.region}:${var.account_id}:")
  function_name    = module.lambda-consumer.function_name
  enabled          = true
  batch_size       = 10
}