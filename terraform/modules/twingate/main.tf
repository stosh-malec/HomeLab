terraform {
  required_providers {
    twingate = {
      source  = "Twingate/twingate"
      version = "~> 3.0" # https://registry.terraform.io/providers/Twingate/twingate/latest
    }
  }
}

resource "kubernetes_namespace" "twingate" {
  metadata {
    name = var.namespace
  }
}

resource "twingate_remote_network" "homelab" {
  name = var.remote_network_name
}

resource "twingate_connector" "connector1" {
  name                   = "${var.remote_network_name}-connector-1"
  remote_network_id      = twingate_remote_network.homelab.id
  status_updates_enabled = true
}

resource "twingate_connector" "connector2" {
  name                   = "${var.remote_network_name}-connector-2"
  remote_network_id      = twingate_remote_network.homelab.id
  status_updates_enabled = true
}

resource "twingate_connector_tokens" "connector1_tokens" {
  connector_id = twingate_connector.connector1.id
}

resource "twingate_connector_tokens" "connector2_tokens" {
  connector_id = twingate_connector.connector2.id
}

resource "kubernetes_secret" "connector1" {
  metadata {
    name      = "twingate-connector-1"
    namespace = kubernetes_namespace.twingate.metadata[0].name
  }

  data = {
    TWINGATE_NETWORK       = var.network
    TWINGATE_ACCESS_TOKEN  = twingate_connector_tokens.connector1_tokens.access_token
    TWINGATE_REFRESH_TOKEN = twingate_connector_tokens.connector1_tokens.refresh_token
  }
}

resource "kubernetes_secret" "connector2" {
  metadata {
    name      = "twingate-connector-2"
    namespace = kubernetes_namespace.twingate.metadata[0].name
  }

  data = {
    TWINGATE_NETWORK       = var.network
    TWINGATE_ACCESS_TOKEN  = twingate_connector_tokens.connector2_tokens.access_token
    TWINGATE_REFRESH_TOKEN = twingate_connector_tokens.connector2_tokens.refresh_token
  }
}

resource "kubernetes_deployment" "connector1" {
  metadata {
    name      = "twingate-connector-1"
    namespace = kubernetes_namespace.twingate.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "twingate-connector-1"
      }
    }

    template {
      metadata {
        labels = {
          app = "twingate-connector-1"
        }
      }

      spec {
        node_selector = var.node1_selector

        container {
          name  = "connector"
          image = "twingate/connector:${var.connector_image_tag}"

          env_from {
            secret_ref {
              name = kubernetes_secret.connector1.metadata[0].name
            }
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "500Mi"
            }
          }

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_non_root            = true
            run_as_user                = 65532
            capabilities {
              drop = ["ALL"]
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_secret.connector1]
}

resource "kubernetes_deployment" "connector2" {
  metadata {
    name      = "twingate-connector-2"
    namespace = kubernetes_namespace.twingate.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "twingate-connector-2"
      }
    }

    template {
      metadata {
        labels = {
          app = "twingate-connector-2"
        }
      }

      spec {
        node_selector = var.node2_selector

        container {
          name  = "connector"
          image = "twingate/connector:${var.connector_image_tag}"

          env_from {
            secret_ref {
              name = kubernetes_secret.connector2.metadata[0].name
            }
          }

          resources {
            requests = {
              cpu    = "50m"
              memory = "200Mi"
            }
            limits = {
              cpu    = "500m"
              memory = "500Mi"
            }
          }

          security_context {
            allow_privilege_escalation = false
            read_only_root_filesystem  = true
            run_as_non_root            = true
            run_as_user                = 65532
            capabilities {
              drop = ["ALL"]
            }
          }
        }
      }
    }
  }

  depends_on = [kubernetes_secret.connector2]
}