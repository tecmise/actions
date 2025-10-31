# resource "aws_ssm_parameter" "parameter" {
#   count = length(local.parameters)
#   name = local.parameters[count.index]["name"]
#   type = "String"
#   value = local.parameters[count.index]["value"]
# }