output "helm_release_name" {
  description = "Name of the Helm release"
  value       = helm_release.minecraft.name
}

output "namespace" {
  description = "Kubernetes namespace"
  value       = var.namespace
}

output "persistent_volume_claim_name" {
  description = "Name of the persistent volume claim"
  value       = kubernetes_persistent_volume_claim.minecraft_data.metadata[0].name
} 