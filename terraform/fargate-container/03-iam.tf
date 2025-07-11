resource "aws_iam_role" "task-execution" {
  name = "execution-${var.application_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  count = var.aws_iam_policy_task_execution_arn != "" ? 1 : 0
  policy_arn = var.aws_iam_policy_task_execution_arn
  role       = aws_iam_role.task-execution.id
}

resource "aws_iam_role" "service" {
  name = "task-${var.application_name}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource aws_iam_role_policy_attachment tasks {
  count      = var.task_policy_arns
  policy_arn = var.task_policy_arns[count.index]
  role       = aws_iam_role.service.id
}
