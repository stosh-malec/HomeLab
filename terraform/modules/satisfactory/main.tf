resource "kubernetes_persistent_volume_claim" "data" {
  count = var.create_persistent_volume_claim ? 1 : 0
  
  metadata {
    name      = var.persistent_volume_claim_name
    namespace = var.namespace
  }
  
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    storage_class_name = var.storage_class_name
  }
}

resource "helm_release" "satisfactory" {
  name       = var.name
  chart      = var.chart_path
  namespace  = var.namespace
  
  # Only wait for completion if explicitly requested
  wait       = var.wait
  
  set {
    name  = "image.repository"
    value = var.image_repository
  }
  
  set {
    name  = "image.tag"
    value = var.image_tag
  }
  
  set {
    name  = "image.pullPolicy"
    value = var.image_pull_policy
  }
  
  set {
    name  = "persistence.enabled"
    value = "true"
  }
  
  set {
    name  = "persistence.existingClaim"
    value = var.persistent_volume_claim_name
  }
  
  set {
    name  = "persistence.mountPath"
    value = var.persistence_mount_path
  }
  
  set {
    name  = "env.MAXPLAYERS"
    value = tostring(var.max_players)
  }
  
  set {
    name  = "env.PGID"
    value = tostring(var.pgid)
  }
  
  set {
    name  = "env.PUID"
    value = tostring(var.puid)
  }
  
  set {
    name  = "env.DEBUG"
    value = var.debug
  }
  
  set {
    name  = "env.SKIPUPDATE"
    value = var.skip_update
  }
  
  set {
    name  = "env.STEAMBETA"
    value = tostring(var.steambeta)
  }
  
  # Using force_update to handle changes when needed
  force_update = false
} 