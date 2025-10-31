variable "topics" {
  type = list(object({
    name = string
    fifo = bool
  }))
}

variable "application" {
  type = string
}