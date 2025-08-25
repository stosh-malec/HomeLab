variable "bucket_name" {
  description = "GCP bucket name for Longhorn backups"
  type        = string
  default     = ""
}

variable "region" {
  description = "GCP region for the bucket"
  type        = string
  default     = "us-central1"
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

variable "gcp_access_key_id" {
  description = "GCP HMAC access key ID for backups"
  type        = string
  sensitive   = true
}

variable "gcp_secret_access_key" {
  description = "GCP HMAC secret access key for backups"
  type        = string
  sensitive   = true
}
