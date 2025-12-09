variable "name" {
  type = string
}

variable "namespace" {
  type = string
}

variable "node_selector" {
  type = string
}

variable "limits_cpu" {
  type = string
  default = "100m"
}

variable "requests_cpu" {
  type = string
  default = "50m"
}

variable "limits_memory" {
  type = string
  default = "128Mi"
}

variable "requests_memory" {
  type = string
  default = "64Mi"
}

variable "enabled_persistence" {
  type = string
  default = false
}

variable "persistence_size" {
  type = string
  default = "1Gi"
}

variable "redis_sub_domain" {
  type = string
}

variable "domain" {
  type = string
}