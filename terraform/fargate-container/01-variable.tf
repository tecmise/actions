variable "application_name" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_id" {
  type = string
}


variable "cpu" {
  type = number
  default = 512
}

variable "memory" {
  type = number
  default = 1024
}


variable network_mode {
  type = string
  default = "awsvpc"
}


variable "desired_count" {
  type = number
  default = 1
}

variable "launch_type" {
  type = string
  default = null
}

variable "requires_compatibilities" {
  type = list(string)
  default = ["FARGATE"]
}

variable "family_name" {
  type = string
}

variable "network_configuration" {
  type = list(object({
    subnets         = list(string)
    security_groups = list(string)
    assign_public_ip = optional(bool, false)
  }))
}

variable "load_balancer" {
  type = list(object({
     target_group_arn = string
     container_name   = string
     container_port   = number
  }))
}

variable "task_policy_arns" {
  type = list(string)
  default = []
}

variable "containers_definitions" {
  type = list(object({
    name         = string
    image        = string
    cpu          = optional(number, null)
    memoryReservation       = optional(number, null)
    essential    = optional(bool, true)
    restart_policy      = optional(bool, true)
    portMappings = list(object({
      containerPort = number
      hostPort      = number
      protocol      = string
    }))
    environment = list(object({
      name  = string
      value = string
    }))

    resourceRequirements = list(object({
      type  = string
      value = string
    }))

    healthCheck = optional(object({
      command     = list(string)
      interval    = number
      timeout     = number
      retries     = number
      startPeriod = number
    }), null)

    logConfiguration = object({
      options   = object({
        stream-prefix = string
      })
    })

  }))
}

variable "service_registries" {
  type = list(object({
    registry_arn = string
  }))
}

variable "aws_iam_policy_task_execution_arn" {
  type = string
  default = ""
}

variable "capacity_provider_strategy" {
  type = list(object({
    capacity_provider = string
    weight = number
    base = number
  }))
  default = []
}