terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "kubernetes" {
  config_path    = var.kube_config_path
  config_context = var.kube_context
}

provider "helm" {
  kubernetes {
    config_path    = var.kube_config_path
    config_context = var.kube_context
  }
}

resource "kubernetes_namespace" "games" {
  metadata {
    name = "games"
  }
}

# Deploy Satisfactory server using the module
module "satisfactory_server" {
  source = "../../modules/satisfactory"

  name      = "satisfactory-server"
  namespace = kubernetes_namespace.games.metadata[0].name

  # Use the existing PVC
  create_persistent_volume_claim = false
  persistent_volume_claim_name   = "satisfactory-files"
  storage_class_name             = "longhorn-static"
  storage_size                   = "20Gi"

  # Specify the chart path to use the custom Helm chart
  chart_path = "satisfactory-server"

  # Server configuration
  max_players = 4
  steambeta   = false
  debug       = "false"
  skip_update = "false"

  # Don't wait for completion as we're importing an existing deployment
  wait = true
}

# Deploy Minecraft server using the module
module "minecraft_server" {
  source = "../../modules/minecraft"

  name             = "minecraft-server"
  namespace        = kubernetes_namespace.games.metadata[0].name
  create_namespace = false

  # Don't create PVC since we're using an existing Longhorn volume
  create_persistent_volume_claim = false
  persistent_volume_claim_name   = "minecraft-server-datadir"
  storage_class_name             = "longhorn"
  storage_size                   = "10Gi"

  # Chart configuration
  chart_repo    = "https://itzg.github.io/minecraft-server-charts/"
  chart_name    = "minecraft"
  chart_version = "4.26.3"

  # Use values file instead of individual settings
  values_file_path = "${path.module}/../../../apps/mc-server/values.yaml"

  # Wait for completion
  wait = true
} 