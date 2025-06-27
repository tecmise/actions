resource "aws_api_gateway_integration_response" "default" {
  count = var.has_integration_response ? 1 : 0
  http_method = var.integration_response_http_method
  resource_id = var.resource_id
  rest_api_id = var.rest_api_id
  status_code = var.integration_response_status_code
  response_templates = var.integration_response_response_templates
  response_parameters = var.integration_response_response_parameters
}
