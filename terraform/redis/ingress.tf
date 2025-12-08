resource "kubernetes_manifest" "redis_ingress" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = var.name
      namespace = var.namespace
      annotations = {
        "kubernetes.io/ingress.class" = "nginx"
        "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
      }
    }
    spec = {
      rules = [
        {
          host = var.redis_host
          http = {
            paths = [
              {
                path     = "/"
                pathType = "Prefix"
                backend = {
                  service = {
                    name = "${var.name}-redis-master"
                    port = {
                      number = 6379
                    }
                  }
                }
              }
            ]
          }
        }
      ]
    }
  }

  depends_on = [helm_release.redis]
}
