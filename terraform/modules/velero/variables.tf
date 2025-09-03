variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_service_account_key" {
  description = "GCP service account JSON key for Velero"
  type        = string
  sensitive   = true
}

variable "bucket_name" {
  description = "GCP bucket name for Velero backups"
  type        = string
}

variable "region" {
  description = "GCP region for the bucket"
  type        = string
  default     = "us-central1"
}

variable "velero_chart_version" {
  description = "Velero Helm chart version"
  type        = string
}

variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = "default"
}

variable "velero_gcp_plugin_version" {
  description = "Velero GCP plugin version"
  type        = string
  default     = "v1.12.1"
}
