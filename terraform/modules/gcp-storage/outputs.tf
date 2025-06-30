output "bucket_name" {
  description = "The name of the GCS bucket"
  value       = google_storage_bucket.longhorn_backup.name
}

output "bucket_url" {
  description = "The URL of the GCS bucket"
  value       = google_storage_bucket.longhorn_backup.url
}

output "longhorn_backup_config" {
  description = "Configuration string for Longhorn backup target"
  value       = "s3://${google_storage_bucket.longhorn_backup.name}@us/"
}

output "service_account_email" {
  description = "Email of the service account for Longhorn"
  value       = google_service_account.longhorn_backup_sa.email
}

output "hmac_access_id" {
  description = "HMAC access ID for S3 compatibility"
  value       = google_storage_hmac_key.longhorn_backup_hmac.access_id
}

output "hmac_secret" {
  description = "HMAC secret for S3 compatibility"
  value       = google_storage_hmac_key.longhorn_backup_hmac.secret
  sensitive   = true
}

output "kubernetes_secret_command" {
  description = "Command to create Kubernetes secret for Longhorn"
  value       = <<-EOT
    kubectl create secret generic longhorn-gcp-backups \\
      --namespace=longhorn-system \\
      --from-literal=AWS_ACCESS_KEY_ID=${google_storage_hmac_key.longhorn_backup_hmac.access_id} \\
      --from-literal=AWS_SECRET_ACCESS_KEY=${google_storage_hmac_key.longhorn_backup_hmac.secret} \\
      --from-literal=AWS_ENDPOINTS=https://storage.googleapis.com
  EOT
} 