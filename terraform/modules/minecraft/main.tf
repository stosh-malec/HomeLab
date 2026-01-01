resource "kubernetes_storage_class" "minecraft_retain" {
  metadata {
    name = "local-path-retain"
  }
  storage_provisioner    = "rancher.io/local-path"
  reclaim_policy        = "Retain"
  volume_binding_mode   = "WaitForFirstConsumer"
  allow_volume_expansion = false
}

resource "kubernetes_persistent_volume_claim" "minecraft_data" {
  metadata {
    name      = "minecraft-server-datadir"
    namespace = var.namespace
    labels = {
      app = "minecraft-server"
    }
  }
  
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    storage_class_name = kubernetes_storage_class.minecraft_retain.metadata[0].name
  }
  
  wait_until_bound = false
}

resource "random_password" "rcon_password" {
  length  = 24
  special = false
}

resource "kubernetes_secret" "rcon" {
  metadata {
    name      = "minecraft-server-rcon"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name"      = "minecraft-server"
      "meta.helm.sh/release-namespace" = var.namespace
    }
  }

  data = {
    "rcon-password" = random_password.rcon_password.result
  }

  lifecycle {
    ignore_changes = [data]
  }
}

resource "kubernetes_secret" "rclone_config" {
  count = var.backup_enabled ? 1 : 0

  metadata {
    name      = "minecraft-server-rclone-config"
    namespace = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "Helm"
    }
    annotations = {
      "meta.helm.sh/release-name"      = "minecraft-server"
      "meta.helm.sh/release-namespace" = var.namespace
    }
  }

  data = {
    "rclone.conf" = <<-EOT
[gcs]
type = google cloud storage
service_account_credentials = ${jsonencode(jsondecode(var.gcp_service_account_key))}
EOT
  }
}

resource "helm_release" "minecraft" {
  name       = "minecraft-server"
  repository = "https://itzg.github.io/minecraft-server-charts/"
  chart      = "minecraft"
  version    = var.chart_version
  namespace  = var.namespace

  values = [
    templatefile("${path.module}/values.yaml", {
      minecraft_version  = var.minecraft_version
      memory_request     = var.memory_request
      cpu_request        = var.cpu_request
      memory_limit       = var.memory_limit
      cpu_limit          = var.cpu_limit
      difficulty         = var.difficulty
      server_type        = var.server_type
      motd               = var.motd
      node_port          = var.node_port
      modpack_type       = var.modpack_type
      modpack_name       = var.modpack_name
      modpack_version    = var.modpack_version
      namespace          = var.namespace
      backup_enabled     = var.backup_enabled
      backup_interval    = var.backup_interval
      backup_bucket_name = var.backup_bucket_name
    })
  ]

  depends_on = [
    kubernetes_persistent_volume_claim.minecraft_data,
    kubernetes_secret.rcon,
    kubernetes_secret.rclone_config
  ]
}