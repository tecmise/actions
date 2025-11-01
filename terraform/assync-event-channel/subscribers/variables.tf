variable "topics" {
  type = list(object({
    name = string
    fifo = bool
    dead_letter = optional(string, null)
  }))
}

variable "queues" {
  type = list(object({
    name = string
    fifo = bool
    topics = list(string)
    dead_letter = string
  }))
}

variable "application" {
  type = string
}

variable "preffix" {
  type = string
}
