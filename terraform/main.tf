provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "aks-northeurope"
}

resource "kubernetes_deployment" "nginx-nap" {
  metadata {
    name = "nginx-nap"
    namespace = "sentence"
    labels = {
      app = "nginx-nap"
    }
  }

  spec {
    replicas = 1

  selector {
      match_labels = {
        app = "nginx-nap"
      }
    }

    template {
      metadata {
        labels = {
          app = "nginx-nap"
        }
        annotations = {
          version = "v1.44"
        }
      }

      spec {
        container {
          image = "registryemeasa.azurecr.io/nginx/nap:v1.0"
          name  = "nginx-nap"
          image_pull_policy = "Always"

          port {
            container_port = "80"
           }
        }
        image_pull_secrets {
          name = "secret-azure-acr"
        }
        }
      }
    }
}

resource "kubernetes_service" "nginx-nap" {
  metadata {
    name = "nginx-nap"
    namespace = "sentence"
  }
  spec {
    selector = {
      app = "nginx-nap"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}

resource "kubernetes_service" "nginx-nap-external" {
  metadata {
    name = "nginx-nap-external"
    namespace = "sentence"
  }
  spec {
    selector = {
      app = "nginx-nap"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}