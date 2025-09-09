variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Name of the kubeconfig context to use"
  type        = string
  default     = "home"
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "gcp_project_id" {
  description = "GCP project ID for Velero"
  type        = string
}

variable "twingate_network" {
  description = "Twingate network name"
  type        = string
}

variable "twingate_api_token" {
  description = "Twingate API token with Read, Write & Provision permissions"
  type        = string
  sensitive   = true
}

variable "twingate_remote_network_name" {
  description = "Name for the Twingate remote network"
  type        = string
}

variable "twingate_connector_image_tag" {
  description = "Docker image tag for Twingate connector (use 'latest' for auto-update)"
  type        = string
  default     = "latest"
} 