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

resource "helm_release" "minecraft" {
  name       = "minecraft-server"
  repository = "https://itzg.github.io/minecraft-server-charts/"
  chart      = "minecraft"
  version    = var.chart_version
  namespace  = var.namespace
  
  values = [
    templatefile("${path.module}/values.yaml", {
      minecraft_version = var.minecraft_version
      memory_request    = var.memory_request
      cpu_request      = var.cpu_request
      memory_limit     = var.memory_limit  
      cpu_limit        = var.cpu_limit
      difficulty       = var.difficulty
      server_type      = var.server_type
      motd            = var.motd
      node_port       = var.node_port
    })
  ]

  depends_on = [kubernetes_persistent_volume_claim.minecraft_data]
}