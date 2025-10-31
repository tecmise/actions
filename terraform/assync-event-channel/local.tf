locals {
  content = jsondecode(file(var.file_name))

  topics = flatten([
      for queue in local.content["publishers"] : { name: queue["name"], fifo: lookup(queue, "fifo", false) }
  ])
  
  parameters = flatten([
    for value in local.content["publishers"] : flatten([
      for key, attr in (lookup(value, "attributes", null) != null ? value["attributes"] : []) : {
        name: "/${var.application}/assync-event-channel/${value["name"]}/${attr["name"]}",
        value: attr["value"]
      }
    ])
  ])
}