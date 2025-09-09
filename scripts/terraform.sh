#!/bin/bash
# Docker-based Terragrunt wrapper to isolate from system Terraform/Terragrunt installations
docker run --rm -it \
  -v $(cd ../../../ && pwd):/workspace \
  -v ~/.config/gcloud:/root/.config/gcloud \
  -v ~/.kube:/root/.kube \
  -w /workspace/terraform/roots/homelab \
  -e GOOGLE_APPLICATION_CREDENTIALS=/root/.config/gcloud/application_default_credentials.json \
  -e KUBECONFIG=/root/.kube/config \
  -e TF_VAR_project_id=${TF_VAR_project_id} \
  -e TF_VAR_bucket_name=${TF_VAR_bucket_name} \
  -e TF_VAR_region=${TF_VAR_region} \
  -e TF_VAR_service_account_email=${TF_VAR_service_account_email} \
  -e TF_VAR_gcp_access_key_id=${TF_VAR_gcp_access_key_id} \
  -e TF_VAR_gcp_secret_access_key=${TF_VAR_gcp_secret_access_key} \
  -e TF_VAR_twingate_network=${TF_VAR_twingate_network} \
  -e TF_VAR_twingate_remote_network_name=${TF_VAR_twingate_remote_network_name} \
  -e TF_VAR_twingate_api_token=${TF_VAR_twingate_api_token} \
  custom-terragrunt "$@"
