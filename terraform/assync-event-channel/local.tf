locals {
  content = jsondecode(file(var.file_name))

  topics = flatten([
      for topic in lookup(local.content, "publishers", []) : { name: topic["name"], fifo: lookup(topic, "fifo", false) }
  ])

  queues = flatten([
    for queue in lookup(local.content, "subscribers", []) : {
      name: queue["name"],
      fifo: lookup(queue, "fifo", false),
      topics: queue.topics
      dead_letter: lookup(queue, "dead_letters", lookup(local.content, "default_dead_letters",  null))
    }
  ])

  topics_to_subscribe = flatten([
    for value in lookup(local.content, "subscribers", []) : flatten([
      for key, topic in (lookup(value, "topics", null) != null ? value["topics"] : []) : { name: topic, fifo: lookup(value, "fifo", false) }
    ])
  ])

  parameters = flatten([
    for value in lookup(local.content, "publishers", []) : flatten([
      for key, attr in (lookup(value, "attributes", null) != null ? value["attributes"] : []) : {
        name: "/${var.application}/assync-event-channel/${value["name"]}/${attr["name"]}",
        value: attr["value"]
      }
    ])
  ])
}