# module "publishers" {
#   count = length(local.topics)
#   source = "./publishers"
#   application = var.application
#   topics = local.topics
# }