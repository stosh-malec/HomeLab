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
resource "google_storage_bucket" "terraform_state" {
  name                        = "${var.project_id}-terraform-state"
  location                    = var.region
  storage_class               = "STANDARD"
  public_access_prevention    = "enforced"
  
  lifecycle {
    prevent_destroy = true
  }
  
  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      num_newer_versions = 3
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket" "velero_backup" {
  name                        = var.velero_bucket_name
  location                    = var.region
  storage_class               = "STANDARD"
  public_access_prevention    = "enforced"
  
  lifecycle {
    prevent_destroy = true
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
resource "google_service_account" "velero_backup_sa" {
  account_id   = "velero-backup-sa"
  display_name = "Velero Backup Service Account"
}
resource "google_storage_bucket_iam_binding" "velero_backup_access" {
  bucket = google_storage_bucket.velero_backup.name
  role   = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.velero_backup_sa.email}",
  ]
}
resource "google_project_iam_member" "velero_compute_storage_admin" {
  project = var.project_id
  role    = "roles/compute.storageAdmin"
  member  = "serviceAccount:${google_service_account.velero_backup_sa.email}"
}

resource "google_project_iam_member" "velero_compute_admin" {
  project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.velero_backup_sa.email}"
}

resource "google_service_account_key" "velero_backup_sa_key" {
  service_account_id = google_service_account.velero_backup_sa.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}