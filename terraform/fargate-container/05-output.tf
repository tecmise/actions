output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.server
}

output "ecs_service_name" {
  value = aws_ecs_service.server
}

output "cloudwatch_log_group_name" {
  value = aws_cloudwatch_log_group.default
}

output "iam_task_execution_role_arn" {
  value = aws_iam_role.task-execution.arn
}

output "iam_service_role_arn" {
  value = aws_iam_role.service.arn
}

output "iam_task_execution_role_id" {
  value = aws_iam_role.task-execution.id
}

output "iam_service_role_id" {
  value = aws_iam_role.service.id
}