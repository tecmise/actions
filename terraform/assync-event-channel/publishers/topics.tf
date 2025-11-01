resource aws_sns_topic topics_fifo {
  for_each = {
    for key, value in var.topics : value.name => value
  }
  name = each.value["fifo"] ? "entity-${each.value["name"]}.fifo" : "entity-${each.value["name"]}"
  fifo_topic = each.value["fifo"]
  tags = {
    application = var.application
    channel = "assync-event-channel"
  }
}