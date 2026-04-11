data "aws_ssm_parameters_by_path" "parameters" {
  count = length(var.parameter_store_preffix)
  path            = var.parameter_store_preffix[count.index]
  recursive       = true
  with_decryption = true
}

locals {
  ssms = flatten([
    for by_path in data.aws_ssm_parameters_by_path.parameters : flatten([
      for index, variableName in by_path.names : {
        name = variableName
        value = by_path.values[index]
      }
    ])
  ])
  variables = {
    for index, variable in local.ssms : variable["name"] => variable["value"]
  }
}

