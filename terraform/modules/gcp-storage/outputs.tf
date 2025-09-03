output "terraform_state_bucket_name" {
  description = "The name of the terraform state GCS bucket"
  value       = google_storage_bucket.terraform_state.name
}

output "terraform_state_bucket_url" {
  description = "The URL of the terraform state GCS bucket"
  value       = google_storage_bucket.terraform_state.url
}

output "velero_backup_bucket_name" {
  description = "The name of the velero backup GCS bucket"
  value       = google_storage_bucket.velero_backup.name
}

output "velero_backup_bucket_url" {
  description = "The URL of the velero backup GCS bucket"
  value       = google_storage_bucket.velero_backup.url
}

output "velero_backup_service_account_email" {
  description = "Email of the service account for velero backups"
  value       = google_service_account.velero_backup_sa.email
}

output "velero_backup_service_account_key_json" {
  description = "Service account key in JSON format for use with Velero"
  value = base64decode(google_service_account_key.velero_backup_sa_key.private_key)
  sensitive = true
} 