resource "aws_cloudwatch_log_group" "default" {
  name              = "/ecs/${var.application_name}"
  retention_in_days = 7
}
