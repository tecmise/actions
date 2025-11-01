resource "aws_ssm_parameter" "parameter" {
  count = length(var.parameters)
  name = var.parameters[count.index]["name"]
  type = "String"
  value = var.parameters[count.index]["value"]
  tags = {
    application = var.application
  }
}
