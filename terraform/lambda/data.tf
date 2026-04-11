data "aws_ssm_parameter" "parameters" {
  for_each = {
    for index, value in local.paths : value["key"] => value["path"]
  }
  name  = each.value
}


locals {

  paths = flatten([
    for env in var.environments : flatten([
      for index, key_var in env.values : {
        path = "/${env.preffix}/${env.kind}/${key_var}"
        key = key_var
      }
    ])
  ])

  variables = {
    for index, variable in data.aws_ssm_parameter.parameters : index => nonsensitive(variable.value)
  }
}
