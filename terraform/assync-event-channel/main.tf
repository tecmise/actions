module "publishers" {
  count = length(local.topics) > 0 ? 1 : 0
  source = "./publishers"
  application = var.application
  topics = local.topics
  parameters = local.parameters
}

module "subscribers" {
  source = "./subscribers"
  count = length(local.queues) > 0 ? 1 : 0
  application = var.application
  topics = local.topics_to_subscribe
  queues = local.queues
  preffix = "auth-serv"
}

