variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the storage bucket"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "Name of the GCP storage bucket for Longhorn backups"
  type        = string
}

variable "create_k8s_secret" {
  description = "Whether to create the Kubernetes secret for Longhorn (requires Kubernetes provider)"
  type        = bool
  default     = false
} 