variable "function_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "retention_in_days" {
  type = number
  default = 3
}

variable "application" {
  type = string
}

variable "memory_size" {
  type = number
  default = 128
}
variable "timeout" {
  default = 15
  type = number
}
variable "s3_bucket" {
  type = string
}
variable "s3_key" {
  type = string
}
variable "runtime" {
  type = string
}
variable "handler" {
  type = string
}
variable "tracing_config_mode" {
  default = "PassThrough"
}
variable "variables" {
  type = map(string)
}

variable "subnet_ids" {
  type = list(string)
  default = []
}
variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
  default = ""
}

variable "security_group_ids" {
  type = list(string)
  default = []
}

variable "policy_arns" {
  type = list(string)
  default = []
}

variable "version_id" {
  type = string
}