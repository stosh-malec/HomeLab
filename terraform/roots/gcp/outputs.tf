output "terraform_state_bucket_name" {
  description = "The name of the terraform state GCS bucket"
  value       = module.storage.terraform_state_bucket_name
}

output "terraform_state_bucket_url" {
  description = "The URL of the terraform state GCS bucket"
  value       = module.storage.terraform_state_bucket_url
}

output "velero_backup_bucket_name" {
  description = "The name of the velero backup GCS bucket"
  value       = module.storage.velero_backup_bucket_name
}

output "velero_backup_bucket_url" {
  description = "The URL of the velero backup GCS bucket"
  value       = module.storage.velero_backup_bucket_url
}

output "velero_backup_service_account_email" {
  description = "Email of the service account for velero backups"
  value       = module.storage.velero_backup_service_account_email
}

output "velero_backup_service_account_key" {
  description = "Service account key in JSON format for use with Velero"
  value       = module.storage.velero_backup_service_account_key_json
  sensitive   = true
}