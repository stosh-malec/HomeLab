remote_state {
  backend = "gcs"
  config = {
    bucket   = "${get_env("TF_VAR_bucket_name")}"
    prefix   = "terraform/gcp"
    project  = "${get_env("TF_VAR_project_id")}"
    location = "${get_env("TF_VAR_region")}"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}
