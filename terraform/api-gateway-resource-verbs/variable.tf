variable "verb" {
  type = string
}

variable "authorization" {
  type = string
  default = "NONE"
}

variable "resource_id" {
  type = string
}

variable "rest_api_id" {
  type = string
}

variable "api_key_required" {
  type = string
  default = false
}

variable "method_request_parameters" {
  type = map(string)
  default = {}
}

variable "method_request_validator_id" {
  type = string
  default = null
}

variable "method_request_models" {
  type = map(string)
  default = {}
}

variable "uri" {
  type = string
}

variable "integration_request_parameters" {
  type = map(string)
  default = {}
}

variable "integration_request_templates" {
  type = map(string)
  default = {}
}

variable "integration_type" {
  type = string
  default = "AWS_PROXY"
}

variable "integration_http_method" {
  default = "POST"
  type = string
}

variable "method_response_status_code" {
  default = "200"
  type = string
}

variable "method_response_models" {
  default = {
    "application/json" = "Empty"
  }
  type = map(string)
}

variable "method_response_parameters" {
  default = {}
  type = map(string)
}

variable "has_integration_response" {
  type = bool
  default = false
}

variable "integration_response_status_code" {
  type = string
}

variable "integration_response_http_method" {
  type = string
}

variable "integration_response_response_templates" {
  type = map(string)
  default = {}
}
variable "integration_response_response_parameters" {
  type = map(string)
  default = {}
}

variable "authorizer_id" {
  type = string
  default = ""
}

variable "append_authorizer_on_request" {
  type = bool
  default = false
}