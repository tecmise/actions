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
      portMappings = value.portMappings
      environment = value.environment
      healthCheck = lookup(value, "healthCheck", null)
      resourceRequirements = lookup(value, "resourceRequirements", [])
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          "awslogs-group"         = aws_cloudwatch_log_group.default.name,
          "awslogs-region"        = var.region,
          "awslogs-stream-prefix" = value.logConfiguration.options.stream-prefix
        }
      }
    }
  ]))

}

resource "aws_ecs_service" "server" {
  name             = var.application_name
  cluster          = var.cluster_id
  task_definition  = aws_ecs_task_definition.server.arn
  desired_count    = var.desired_count
  launch_type      = var.launch_type
  platform_version = var.launch_type == "FARGATE" ? "LATEST" : null

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

