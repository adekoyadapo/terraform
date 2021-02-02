provider "kubernetes" {
  host = "https://kubernetes.docker.internal:6443"

  username = "terraform-user"
  password = "ABCDE12345"
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-scale"
    labels = {
      App = "ScalableNginx"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableNginx"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "example"

          port {
            container_port = 80
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-scalable"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

output "node_port" {
  value = kubernetes_service.nginx.spec.0.port[0].node_port
}
