terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.1.0" # https://registry.terraform.io/providers/hashicorp/google/latest
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

module "storage" {
  source = "../../modules/gcp-storage"

  project_id          = var.project_id
  region              = var.region
  velero_bucket_name  = var.velero_bucket_name
}

module "kms" {
  source = "../../modules/gcp-kms"

  project_id = var.project_id
  region     = var.region
}