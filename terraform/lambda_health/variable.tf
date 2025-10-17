
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

variable "payload" {
  type = object({
    resource     = optional(string, "/health/check"),
    path         = optional(string, "/health/check"),
    httpMethod   = optional(string, "GET"),
    headers      = optional(map(string), {
      Accept = "*/*",
    }),
    resourcePath = optional(string, "/health/check"),
    body         = optional(string, "/health/check"),
  })
  default = {
    resource     = "/health/check",
    path         = "/health/check",
    httpMethod   = "GET",
    headers      = {
      Accept = "*/*",
    },
    resourcePath = "/health/check",
    body         = "",
  }
}