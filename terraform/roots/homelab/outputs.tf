output "kubernetes_namespaces" {
  description = "Namespaces managed by Terraform"
  value       = kubernetes_namespace.games.metadata[0].name
}

output "satisfactory_server" {
  description = "Satisfactory server details"
  value = {
    helm_release_name       = module.satisfactory_server.helm_release_name
    namespace               = module.satisfactory_server.namespace
    persistent_volume_claim = module.satisfactory_server.persistent_volume_claim_name
  }
}

output "minecraft_server" {
  description = "Minecraft server details"
  value = {
    helm_release_name       = module.minecraft_server.helm_release_name
    namespace               = module.minecraft_server.namespace
    persistent_volume_claim = module.minecraft_server.persistent_volume_claim_name
  }
} 