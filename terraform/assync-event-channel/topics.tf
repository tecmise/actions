resource aws_sns_topic topics_fifo {
  for_each = local.topics_fifo
  name = each.value["fifo"] ? "entity-${each.key}.fifo" : "entity-${each.key}"
  fifo_topic = each.value["fifo"]
  tags = {
    application = var.application
  }
}