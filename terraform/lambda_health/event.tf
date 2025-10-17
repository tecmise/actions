resource "aws_cloudwatch_event_rule" "health_check" {
  name                = "${var.function_name}-lambda-health-check"
  description         = "lambda health check"
  schedule_expression = "cron(* * * * ? *)"
}

resource "aws_cloudwatch_event_target" "health_check" {
  rule       = aws_cloudwatch_event_rule.health_check.name
  arn        = var.lambda_arn
  input      = jsonencode(local.payload)
}

resource "aws_lambda_permission" "health_check" {
  statement_id  = "${var.function_name}-health-check"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.health_check.arn
}