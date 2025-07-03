resource "kubernetes_namespace" "namespace" {
  count = var.create_namespace ? 1 : 0
  
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_persistent_volume_claim" "data" {
  count = var.create_persistent_volume_claim ? 1 : 0
  
  metadata {
    name      = var.persistent_volume_claim_name
    namespace = var.namespace
    labels = {
      app                       = var.name
      "app.kubernetes.io/name"  = "minecraft"
      "app.kubernetes.io/instance" = var.name
    }
  }
  
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.storage_size
      }
    }
    storage_class_name = var.storage_class_name
  }
}

resource "helm_release" "minecraft" {
  name       = var.name
  repository = var.chart_repo
  chart      = var.chart_name
  version    = var.chart_version
  namespace  = var.namespace
  
  wait       = var.wait
  
  # Use values file if provided
  values = [
    var.values_file_path != "" ? file(var.values_file_path) : ""
  ]
  
  # Only set these values if not using a values file
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      # Basic Minecraft server configuration
      name  = "image.tag"
      value = var.image_tag
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "image.repository"
      value = var.image_repository
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "minecraftServer.eula"
      value = "true"
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "minecraftServer.type"
      value = var.minecraft_type
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "minecraftServer.version"
      value = var.minecraft_version
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "resources.requests.memory"
      value = var.resources_requests_memory
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "resources.requests.cpu"
      value = var.resources_requests_cpu
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "minecraftServer.difficulty"
      value = var.difficulty
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "minecraftServer.gameMode"
      value = var.gamemode
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "minecraftServer.motd"
      value = var.motd
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "minecraftServer.levelType"
      value = var.level_type
    }
  }
  
  dynamic "set" {
    for_each = var.values_file_path == "" ? [1] : []
    content {
      name  = "minecraftServer.memory"
      value = var.minecraft_memory
    }
  }
  
  # Always set these values regardless of values file
  # Persistence configuration - this needs to be set to use the PVC we create
  set {
    name  = "persistence.dataDir.enabled"
    value = "true"
  }
  
  set {
    name  = "persistence.dataDir.existingClaim"
    value = var.persistent_volume_claim_name
  }
  
  # Removed CurseForge config section since we're not using it
  
  set {
    name  = "minecraftServer.cfParallelDownloads"
    value = var.cf_parallel_downloads
  }
  
  # Service config
  set {
    name  = "service.type"
    value = var.service_type
  }
  
  set {
    name  = "service.nodePort"
    value = var.node_port
  }
  
  # Additional environment variables can be set dynamically
  dynamic "set" {
    for_each = var.extra_env_vars
    content {
      name  = "extraEnv.${set.key}"
      value = set.value
    }
  }
  
  # Force update to handle changes when needed
  force_update = false
} 