
variable "bucket_lambda" {
  type = string
}

variable "versionament" {
  type = string
}

variable "variables" {
  type = map(string)
}

variable "security_groups" {
  type = list(string)
}

variable "policy_arns" {
  type = list(string)
}

variable "consumer" {
  type = string
}

variable "application_name" {
  type = string
}

variable "artifact_name" {
  type = string
}

variable "dead_leaders_arn" {
  type = string
}

variable "queue_arn" {
  type = string
}

variable "webhook_discord" {
  type = string
}


variable "subnet_ids" {
  type = list(string)
}