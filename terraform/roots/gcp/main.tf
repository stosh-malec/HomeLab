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

module "storage" {
  source = "../../modules/gcp-storage"

  project_id  = var.project_id
  region      = var.region
  bucket_name = var.bucket_name
} 