module "methods" {
  for_each = {
    for verb in local.methods : verb => verb
  }
  source                          = "git::https://github.com/tecmise/actions//terraform/api-gateway-resource-verbs?ref=v1.0.5"
  resource_id                     = var.resource_id
  rest_api_id                     = var.rest_api_id
  uri                             = var.uri
  verb                            = each.value
  api_key_required                = each.value != "OPTIONS"
  integration_type                = each.value != "OPTIONS" ? "AWS_PROXY" : "MOCK"
  integration_http_method         = each.value != "OPTIONS" ? "POST" : "OPTIONS"
  integration_response_http_method = each.value != "OPTIONS" ? "POST" : "OPTIONS"
  has_integration_response        = each.value == "OPTIONS"
  integration_response_status_code = "200"
  method_response_models = {
    "application/json" = "Empty"
  }
  method_request_parameters = {}
  authorization                    = each.value != "OPTIONS" ? "CUSTOM" : "NONE"
  authorizer_id                    = each.value != "OPTIONS" ? var.custom_authorizer_id : ""
  method_response_parameters = each.value != "OPTIONS" ? {} : {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = true
  }
  integration_response_response_parameters = each.value != "OPTIONS" ? {} : {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,Authorization,X-Amz-Date,X-Api-Key,X-Amz-Security-Token,X-Requested-With,Cache-Control'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,GET,PUT,POST,DELETE,PATCH,HEAD'",
    "method.response.header.Access-Control-Allow-Origin"  = "'${var.cors_origin_domain}'",
  }

  integration_request_templates = each.value != "OPTIONS" ? {} : {
    "application/json" = "{ statusCode: 200 }"
  }


}

