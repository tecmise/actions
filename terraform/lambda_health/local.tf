
locals {
  payload = {
    resource = var.path,
    path = var.path,
    httpMethod = var.method,
    headers = {
      Accept = "*/*",
    },
    resourcePath = var.path,
    body = var.body
  }
}