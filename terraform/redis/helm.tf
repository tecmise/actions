//https://artifacthub.io/packages/helm/bitnami/redis
resource "helm_release" "redis" {
  name       = var.name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "redis"
  version    = "24.0.0"
  namespace  = var.namespace
  create_namespace = true
  recreate_pods = true
  timeout = 600
  set = [
    {
      name  = "architecture"
      value = "standalone"
    },
    {
      name  = "metrics.enabled"
      value = "true"
    },
    {
      name  = "replica.nodeSelector.nodegroup-type"
      value = var.node_selector
    },
    {
      name  = "master.nodeSelector.nodegroup-type"
      value = var.node_selector
    },
    {
      name  = "master.resources.limits.cpu"
      value = var.limits_cpu
    },
    {
      name  = "master.resources.requests.cpu"
      value = var.requests_cpu
    },
    {
      name  = "master.resources.limits.memory"
      value = var.limits_memory
    },
    {
      name  = "master.resources.requests.memory"
      value = var.requests_memory
    },
    {
      name  = "master.persistence.enabled"
      value = var.enabled_persistence
    },
    {
      name  = "replica.persistence.enabled"
      value = var.enabled_persistence
    },
    {
      name = "master.persistence.size"
      value = var.persistence_size
    },
    {
      name = "replica.persistence.size"
      value = var.persistence_size
    }
  ]
}

