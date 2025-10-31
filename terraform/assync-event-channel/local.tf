locals {
  content = endswith(var.file_name, ".json") ? jsondecode(file("content.json")) : yamldecode(file("content.yaml"))

  topics_fifo = {
    for queue in local.content["publishers"] : queue["name"] => queue
  }
  parameters = flatten([
    for value in local.content["publishers"] : flatten([
      for key, attr in (value["attributes"] != null ? value["attributes"] : []) : {
        name: "/${var.application}/assync-event-channel/${value["name"]}/${attr["name"]}",
        value: attr["value"]
      }
    ])
  ])
}