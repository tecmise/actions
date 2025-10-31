locals {
  content = jsondecode(file(var.file_name))

  topics_fifo = {
    for queue in local.content["publishers"] : queue["name"] => queue
  }
  parameters = flatten([
    for value in local.content["publishers"] : flatten([
      for key, attr in (lookup(value, "attributes", null) != null ? value["attributes"] : []) : {
        name: "/${var.application}/assync-event-channel/${value["name"]}/${attr["name"]}",
        value: attr["value"]
      }
    ])
  ])
}