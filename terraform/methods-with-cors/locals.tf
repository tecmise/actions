locals {
  methods = distinct(var.enabled_cors ? concat(var.methods, ["OPTIONS"]) : var.methods)
}