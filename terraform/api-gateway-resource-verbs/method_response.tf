resource "aws_api_gateway_method_response" "default" {
  depends_on                = [ aws_api_gateway_method.default]
  http_method               = aws_api_gateway_method.default.http_method
  resource_id               = var.resource_id
  rest_api_id               = var.rest_api_id
  status_code               = var.method_response_status_code
  response_models           = var.method_response_models
  response_parameters       = var.method_response_parameters
  lifecycle {
    create_before_destroy = true
  }
}
