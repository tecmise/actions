resource "aws_ssm_parameter" "roles_parameter" {
  name = "/api-gateway/${var.rest_api_id}/${var.resource_id}/${var.verb}/roles"
  type = "StringList"
  value = join(",", var.roles)
}

