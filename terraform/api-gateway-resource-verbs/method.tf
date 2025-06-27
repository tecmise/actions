resource "aws_api_gateway_method" "default" {
  authorization     = var.authorization
  http_method       = var.verb
  resource_id       = var.resource_id
  rest_api_id       = var.rest_api_id
  api_key_required  = var.api_key_required
  request_parameters = var.method_request_parameters
  authorizer_id      = var.authorizer_id
  request_models = var.method_request_models
  request_validator_id = var.method_request_validator_id
  lifecycle {
    create_before_destroy = true
  }
}
