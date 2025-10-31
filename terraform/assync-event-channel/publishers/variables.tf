variable "topics" {
  type = list(object({
    name = string
    fifo = bool
  }))
}

variable "parameters" {
  type = list(object({
    name  = string
    value = string
  }))
}

variable "application" {
  type = string
}