output "lambda_arn" {
  value = aws_lambda_function.default.arn
}

output "function_name" {
  value = aws_lambda_function.default.function_name
}

output "invoke_arn" {
  value = aws_lambda_function.default.invoke_arn
}

output "role_id" {
  value = aws_iam_role.default.id
}

output "role_arn" {
  value = aws_iam_role.default.arn
}