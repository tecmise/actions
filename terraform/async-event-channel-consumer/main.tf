module "lambda-consumer" {
  source              = "git::https://github.com/tecmise/actions//terraform/lambda?ref=v4.2.3"
  function_name       = var.consumer
  tags                = {
    application       = var.consumer
  }
  s3_bucket           = var.bucket_lambda
  s3_key              = "${var.application_name}/${var.versionament}/${var.artifact_name}.zip"
  runtime             = "provided.al2023"
  handler             = "bootstrap"
  variables           = merge(var.variables, {
    CONSUMER = var.consumer
  })
  policy_arns         = var.policy_arns
  security_group_ids  = var.security_groups
}

