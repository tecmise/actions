resource "aws_ssm_parameter" "roles_parameter" {
  count = length(var.roles) > 0 ? 1 : 0
  name = "/api-gateway/${var.rest_api_id}/${var.resource_id}/${var.verb}/roles"
  type = "String"
  value = join(",", var.roles)
}

