terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a KMS keyring
resource "google_kms_key_ring" "sops_key_ring" {
  name     = var.keyring_name
  location = var.region
}

# Create a KMS key
resource "google_kms_crypto_key" "sops_key" {
  name     = var.key_name
  key_ring = google_kms_key_ring.sops_key_ring.id
  purpose  = "ENCRYPT_DECRYPT"

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "SOFTWARE"
  }
}

# Grant permissions to use the key (optional)
resource "google_kms_crypto_key_iam_binding" "sops_key_binding" {
  crypto_key_id = google_kms_crypto_key.sops_key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  members = [
    "serviceAccount:${var.service_account_email}"
  ]
}
