output "kms_keyring_name" {
  description = "Name of the KMS keyring"
  value       = google_kms_key_ring.sops_key_ring.name
}

output "kms_key_name" {
  description = "Name of the KMS key"
  value       = google_kms_crypto_key.sops_key.name
}

output "kms_key_id" {
  description = "Full resource ID of the KMS key"
  value       = google_kms_crypto_key.sops_key.id
}

output "sops_kms_resource" {
  description = "KMS resource identifier for SOPS configuration"
  value       = "gcpkms:projects/${var.project_id}/locations/${var.region}/keyRings/${var.keyring_name}/cryptoKeys/${var.key_name}"
}
