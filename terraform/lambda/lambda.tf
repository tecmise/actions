resource "aws_lambda_function" "default" {
  depends_on = [aws_iam_role.default]
  function_name = var.function_name
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  runtime       = var.runtime
  handler       = var.handler
  role          = aws_iam_role.default.arn
  timeout       = var.timeout
  memory_size   = var.memory_size
  source_code_hash = data.aws_s3_bucket_object.lambda_zip.etag
  architectures = ["arm64"]
  s3_object_version = var.version_id
  dynamic "vpc_config" {
    for_each = local.vpc_config
    content {
      subnet_ids         = vpc_config.value["subnet_ids"]
      security_group_ids = vpc_config.value["security_group_ids"]
    }
  }

  tracing_config {
    mode = var.tracing_config_mode
  }

  tags = var.tags
  environment {
    variables = var.variables
  }
}

locals {
  emptyList = []
  vpc_valid = [{
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }]
  vpc_config = length(var.subnet_ids) > 0 && length(var.security_group_ids) > 0 ? local.vpc_valid : local.emptyList

}

data "aws_s3_bucket_object" "lambda_zip" {
  bucket = var.s3_bucket
  key    = var.s3_key
}
