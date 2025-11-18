resource "aws_ecs_service" "server" {
  name             = var.application_name
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.server.arn
  desired_count    = var.desired_count
  launch_type      = var.launch_type
  platform_version = var.launch_type == "FARGATE" ? "LATEST" : null
  enable_execute_command = true

  dynamic "service_connect_configuration" {
    for_each = toset(var.service_connect_configuration)
    content {
      enabled = service_connect_configuration.value.enabled
      namespace = service_connect_configuration.value.namespace

      service {
        port_name = service_connect_configuration.value.service["port_name"]
        discovery_name = service_connect_configuration.value.service["discovery_name"]

        dynamic "client_alias" {
          for_each = service_connect_configuration.value.service["client_alias"]
          content {
            port = client_alias.value["port"]
            dns_name = client_alias.value["dns_name"]
          }
        }
      }
    }
  }

  dynamic "service_registries" {
    for_each = toset(var.service_registries)
    content {
      registry_arn = service_registries.value.registry_arn
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = toset(var.capacity_provider_strategy)
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight = capacity_provider_strategy.value.weight
      base = capacity_provider_strategy.value.base
    }
  }

  dynamic "network_configuration" {
    for_each = toset(var.network_configuration)
    content {
      subnets         = network_configuration.value.subnets
      security_groups = network_configuration.value.security_groups
      assign_public_ip = network_configuration.value.assign_public_ip
    }
  }

  dynamic "load_balancer" {
    for_each = toset(var.load_balancer)
    content {
     target_group_arn = load_balancer.value.target_group_arn
     container_name   = load_balancer.value.container_name
     container_port   = load_balancer.value.container_port
    }
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
}


resource "aws_ecs_task_definition" "server" {
  family                   = var.family_name
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task-execution.arn
  task_role_arn            = aws_iam_role.service.arn
  container_definitions    = jsonencode(flatten([
    for index, value in var.containers_definitions : {
      name         = value.name
      image        = value.image
      essential    = value.essential
      cpu          = value.cpu
      memoryReservation       = value.memoryReservation
      resourceRequirements = value.resourceRequirements
      restartPolicy = {
        enabled = value.restart_policy
      }
      portMappings = value.portMappings
      environment = value.environment
      healthCheck = lookup(value, "healthCheck", null)
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.default.name,
          "awslogs-region"        = var.region,
          "awslogs-stream-prefix" = var.application_name
        }
      }
    }
  ]))

}


