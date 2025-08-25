remote_state {
  backend = "gcs"
  config = {
    bucket   = "${get_env("TF_VAR_bucket_name", "your-existing-bucket-name")}"
    prefix   = "terraform/gcp"
    project  = "${get_env("TF_VAR_project_id", "your-gcp-project-id")}"
    location = "${get_env("TF_VAR_region", "us-central1")}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
