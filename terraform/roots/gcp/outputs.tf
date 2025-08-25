output "storage_bucket_name" {
  description = "The name of the GCS bucket"
  value       = module.storage.bucket_name
}

output "storage_bucket_url" {
  description = "The URL of the GCS bucket"
  value       = module.storage.bucket_url
}

output "longhorn_backup_config" {
  description = "Configuration string for Longhorn backup target"
  value       = module.storage.longhorn_backup_config
}

output "hmac_access_id" {
  description = "HMAC access ID for S3 compatibility"
  value       = module.storage.hmac_access_id
}

output "hmac_secret" {
  description = "HMAC secret for S3 compatibility"
  value       = module.storage.hmac_secret
  sensitive   = true
}

output "kubernetes_secret_command" {
  description = "Command to create Kubernetes secret for Longhorn"
  value       = module.storage.kubernetes_secret_command
  sensitive = true
}

output "kms_keyring_name" {
  description = "Name of the KMS keyring"
  value       = module.kms.kms_keyring_name
}

output "kms_key_name" {
  description = "Name of the KMS key"
  value       = module.kms.kms_key_name
}

output "sops_kms_resource" {
  description = "KMS resource identifier for SOPS configuration"
  value       = module.kms.sops_kms_resource
}