terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38" # https://registry.terraform.io/providers/hashicorp/kubernetes/latest
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0.2" # https://registry.terraform.io/providers/hashicorp/helm/latest
    }
    twingate = {
      source  = "Twingate/twingate"
      version = "~> 3.0" # https://registry.terraform.io/providers/Twingate/twingate/latest
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6" # https://registry.terraform.io/providers/hashicorp/random/latest
    }
  }
}

provider "kubernetes" {
  config_path    = var.kube_config_path
  config_context = var.kube_context
}

provider "helm" {
  kubernetes = {
    config_path    = var.kube_config_path
    config_context = var.kube_context
  }
}
data "terraform_remote_state" "gcp" {
  backend = "gcs"
  config = {
    bucket = "${var.gcp_project_id}-terraform-state"
    prefix = "terraform/gcp"
  }
}
module "velero" {
  source = "../../modules/velero"

  gcp_project_id            = var.gcp_project_id
  gcp_service_account_key   = data.terraform_remote_state.gcp.outputs.velero_backup_service_account_key
  bucket_name               = data.terraform_remote_state.gcp.outputs.velero_backup_bucket_name
  region                    = var.region
  kube_config_path          = var.kube_config_path
  kube_context              = var.kube_context
  velero_chart_version      = "10.1.1" #https://artifacthub.io/packages/helm/vmware-tanzu/velero
  velero_gcp_plugin_version = "v1.12.1" #https://github.com/vmware-tanzu/velero-plugin-for-gcp/releases
}

resource "kubernetes_namespace" "games" {
  metadata {
    name = "games"
  }
}

module "minecraft_server" {
  source = "../../modules/minecraft"

  namespace        = kubernetes_namespace.games.metadata[0].name
  chart_version    = "4.26.3" # https://artifacthub.io/packages/helm/minecraft-server-charts/minecraft
  minecraft_version = "1.21.10" # https://feedback.minecraft.net/hc/en-us/sections/360001186971-Release-Changelogs
  difficulty       = "normal"
  motd            = "2026 Minecraft Hits Diff"
  node_port       = 30013
  server_type      = "MODRINTH"
  modpack_type     = "MODRINTH"
  modpack_name     = "vanilla-perfected"
  modpack_version  = "1.0.0+1.21.10"
  memory_request   = "8Gi"
  cpu_request     = "2000m"
  memory_limit    = "8Gi"
  cpu_limit       = "2000m"
  storage_size    = "20Gi"

  # World backup to GCS
  backup_enabled          = true
  backup_interval         = "24h"
  backup_bucket_name      = data.terraform_remote_state.gcp.outputs.velero_backup_bucket_name
  gcp_service_account_key = data.terraform_remote_state.gcp.outputs.velero_backup_service_account_key
} 

module "twingate" {
  source = "../../modules/twingate"
  
  namespace           = "twingate"
  network             = var.twingate_network
  api_token           = var.twingate_api_token
  remote_network_name = var.twingate_remote_network_name
  connector_image_tag = var.twingate_connector_image_tag
  
  node1_selector = {
    "kubernetes.io/hostname" = "k3s-worker-2"
  }
  
  node2_selector = {
    "kubernetes.io/hostname" = "k3s-worker-slim"
  }
}