resource "aws_iam_role" "default" {
  name = var.function_name
  tags = var.tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      }
    ]
  })
}

data "aws_iam_policy_document" "default" {
  statement {
    effect = "Allow"
    actions = [
      "lambda:InvokeFunction",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]
    resources = [
      "${aws_cloudwatch_log_group.default.arn}:*",
      "${aws_lambda_function.default.arn}:*",
    ]
  }
}

data "aws_iam_policy_document" "network_interfaces" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface"
    ]
    resources = [
      "*",
    ]
  }
}


resource "aws_iam_role_policy" "default" {
  name   = "${var.function_name}-default"
  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_iam_role_policy" "network" {
  name   = "${var.function_name}-network"
  role   = aws_iam_role.default.id
  policy = data.aws_iam_policy_document.network_interfaces.json
}


resource "aws_iam_role_policy_attachment" "notifier_policy" {
  count      = length(var.policy_arns)
  role       = aws_iam_role.default.id
  policy_arn = var.policy_arns[count.index]
}