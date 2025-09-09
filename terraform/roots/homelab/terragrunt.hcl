remote_state {
  backend = "gcs"
  config = {
    bucket   = "${get_env("TF_VAR_project_id")}-terraform-state"
    prefix   = "terraform/homelab"
    project  = "${get_env("TF_VAR_project_id")}"
    location = "${get_env("TF_VAR_region", "us-central1")}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

# This dependency ensures that GCP resources are created first
dependency "gcp" {
  config_path = "../gcp"
}
