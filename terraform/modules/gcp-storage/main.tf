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

resource "google_storage_bucket" "longhorn_backup" {
  name          = var.bucket_name
  location      = var.region
  storage_class = "STANDARD"  # Free tier

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  
  versioning {
    enabled = false 
  }

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_service_account" "longhorn_backup_sa" {
  account_id   = "longhorn-backup-sa"
  display_name = "Longhorn Backup Service Account"
}

resource "google_storage_bucket_iam_binding" "bucket_access" {
  bucket = google_storage_bucket.longhorn_backup.name
  role   = "roles/storage.objectAdmin"
  members = [
    "serviceAccount:${google_service_account.longhorn_backup_sa.email}",
  ]
}

resource "google_storage_hmac_key" "longhorn_backup_hmac" {
  service_account_email = google_service_account.longhorn_backup_sa.email
}