data "aws_sns_topic" "topics" {
  for_each = local.topics
  name = each.value["fifo"] ? "entity-${each.value["name"]}.fifo" : "entity-${each.value["name"]}"
}


data "aws_sqs_queue" "dead_letters" {
  count = length(local.dead_letters_queue)
  name = local.dead_letters_queue[count.index]["fifo"] ? "${local.dead_letters_queue[count.index]["dead_letter"]}.fifo" : local.dead_letters_queue[count.index]["dead_letter"]
}



