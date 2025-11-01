locals {
  topics = {
    for index, value in var.topics : value.name => value
  }

  dead_letters_queue = flatten([
    for value in var.queues : value if value.dead_letter != null
  ])

  queues = {
    for index, value in var.queues : value.name => value
  }

  topics_to_subscribe = flatten([
    for value in var.queues : flatten([
      flatten([
        for value_sub in value.topics : {
          name = value_sub
          queue = value.name
          fifo = value.fifo
        }
      ])
    ])
  ])


}