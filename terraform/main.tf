provider "kubernetes" {
  host = "https://aks-matt-eu-dns-8dc14823.hcp.northeurope.azmk8s.io:443"

  client_certificate     = base64decode(TF_VAR_client_certificate)
  client_key             = base64decode(TF_VAR_client_key)
  cluster_ca_certificate = base64decode(TF_VAR_cluster_ca_certificate)
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