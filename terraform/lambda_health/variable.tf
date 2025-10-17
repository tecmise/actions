
variable "path" {
  type = string
  default = "/health/check"
}

variable "method" {
  type = string
  default = "GET"
}

variable "body" {
  type = object({})
  default = {}
}

variable "lambda_arn" {
  type = string
}

variable "function_name" {
  type = string
}