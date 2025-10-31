locals {
  content = jsondecode(file(var.file_name))

  topics_fifo = {
    for queue in local.content["publishers"] : queue["name"] => queue
  }
  parameters = flatten([
    for value in local.content["publishers"] : flatten([
      for key, attr in (containskey(value, "attributes") && value["attributes"] != null ? value["attributes"] : []) : {
        name: "/${var.application}/assync-event-channel/${value["name"]}/${attr["name"]}",
        value: attr["value"]
      }
    ])
  ])
}