provider "kubernetes" {
}

resource "kubernetes_deployment" "nginx-nap" {
  metadata {
    name = "nginx-nap"
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
        }
      }
    }
}

resource "kubernetes_service" "nginx-nap" {
  metadata {
    name = "nginx-nap"
    labels {
      app = "nginx-nap"
      service = "nginx-nap"
    }
  }
  spec {
    selector = {
      app = "nginx-nap"
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_service" "nginx-nap-external" {
  metadata {
    name = "nginx-nap-external"
    labels {
      app = "nginx-nap"
      service = "nginx-nap"
    }
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