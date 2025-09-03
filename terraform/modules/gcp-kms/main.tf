terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.1.0"
    }
  }
}
provider "google" {
  project = var.project_id
  region  = var.region
}
resource "google_kms_key_ring" "sops_key_ring" {
  name     = var.keyring_name
  location = var.region
}
resource "google_kms_crypto_key" "sops_key" {
  name     = var.key_name
  key_ring = google_kms_key_ring.sops_key_ring.id
  purpose  = "ENCRYPT_DECRYPT"

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "SOFTWARE"
  }
}
