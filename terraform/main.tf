variable "client_certificate" {
  type = string
}
variable "client_key" {
  type = string
}
variable "cluster_ca_certificate" {
  type = string
}

provider "kubernetes" {
  host = "https://aks-mdi-k8s-lab-devsecops-cf23e3e1.hcp.francecentral.azmk8s.io:443"

  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
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
          version = "${formatdate("YYYYMMDD hh:mm:ss", timestamp())}"
        }
      }

      spec {
        container {
          image = "registryemeasa.azurecr.io/nginx/nap:tf-cloud-v1.0"
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
