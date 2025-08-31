variable "methods" {
  type = list(string)
}

variable "enabled_cors" {
  type = bool
  default = false
}

variable "cors_origin_domain" {
  type = string
  default = "*"
}

variable "custom_authorizer_id" {
  type = string
}

variable "resource_id" {
  type = string
}

variable "rest_api_id" {
  type = string
}

variable "uri" {
  type = string
}
