variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "bucket_name" {
  description = "Name of the GCP storage bucket for Longhorn backups"
  type        = string
}

variable "keyring_name" {
  description = "Name of the KMS keyring for SOPS encryption"
  type        = string
  default     = "sops-keyring"
}

variable "key_name" {
  description = "Name of the KMS key for SOPS encryption"
  type        = string
  default     = "sops-key"
}

variable "service_account_email" {
  description = "Service account email that will be granted permission to use the KMS key"
  type        = string
}