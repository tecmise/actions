resource "aws_lambda_permission" "default" {
  statement_id  = "sqs-event-trigger-${var.consumer}"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda-consumer.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = var.queue_arn
}

resource "aws_lambda_event_source_mapping" "default" {
  event_source_arn = var.queue_arn
  function_name    = module.lambda-consumer.function_name
  enabled          = true
  batch_size       = 10
}