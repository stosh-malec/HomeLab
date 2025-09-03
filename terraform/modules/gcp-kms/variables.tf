variable "project_id" {
  description = "GCP project ID"
  type        = string
}
variable "region" {
  description = "GCP region for the key"
  type        = string
  default     = "us-central1"
}
variable "keyring_name" {
  description = "Name of the KMS keyring"
  type        = string
  default     = "sops-keyring"
}
variable "key_name" {
  description = "Name of the KMS key"
  type        = string
  default     = "sops-key"
}