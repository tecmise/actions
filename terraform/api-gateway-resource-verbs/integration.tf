resource "aws_api_gateway_integration" "default" {
  count                     = var.vpc_link_id == null ? 1 : 0
  depends_on                = [  aws_api_gateway_method.default ]
  http_method               = aws_api_gateway_method.default.http_method
  integration_http_method   = var.integration_http_method
  resource_id               = var.resource_id
  rest_api_id               = var.rest_api_id
  uri                       = var.uri
  type                      = var.integration_type
  request_parameters        = var.integration_request_parameters
  request_templates         = var.append_authorizer_on_request ? merge(local.authorizer_appender, var.integration_request_templates) : var.integration_request_templates
}



resource "aws_api_gateway_integration" "vpc_link" {
  count                     = var.vpc_link_id != null ? 1 : 0
  resource_id               = var.resource_id
  rest_api_id               = var.rest_api_id
  http_method               = aws_api_gateway_method.default.http_method
  integration_http_method   = var.integration_http_method
  uri                       = var.uri
  type                      = "HTTP_PROXY"
  connection_type           = "VPC_LINK"
  connection_id             = var.vpc_link_id
  request_parameters        = var.integration_request_parameters
  request_templates         = var.append_authorizer_on_request ? merge(local.authorizer_appender, var.integration_request_templates) : var.integration_request_templates
}
