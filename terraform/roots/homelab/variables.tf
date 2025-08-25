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

variable "bucket_name" {
  description = "Name of the GCP storage bucket for Longhorn backups"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "gcp_access_key_id" {
  description = "GCP HMAC access key ID for Longhorn backups"
  type        = string
  sensitive   = true
}

variable "gcp_secret_access_key" {
  description = "GCP HMAC secret access key for Longhorn backups"
  type        = string
  sensitive   = true
} 