resource "aws_cloudwatch_log_group" "default" {
  name = "/aws/lambda/${var.function_name}"
  retention_in_days = var.retention_in_days
}