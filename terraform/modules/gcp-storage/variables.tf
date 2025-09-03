variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region for the storage bucket"
  type        = string
  default     = "us-central1"
}

variable "velero_bucket_name" {
  description = "Name of the GCP storage bucket for Velero backups"
  type        = string
} 