variable "name" {
  description = "Name of the Minecraft server"
  type        = string
  default     = "minecraft-server"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy into"
  type        = string
  default     = "games"
}

variable "create_namespace" {
  description = "Whether to create the namespace"
  type        = bool
  default     = false
}

variable "create_persistent_volume_claim" {
  description = "Whether to create a persistent volume claim"
  type        = bool
  default     = true
}

variable "persistent_volume_claim_name" {
  description = "Name of the persistent volume claim"
  type        = string
  default     = "minecraft-server-datadir"
}

variable "storage_size" {
  description = "Size of the persistent volume"
  type        = string
  default     = "1Gi"
}

variable "storage_class_name" {
  description = "Storage class name"
  type        = string
  default     = "longhorn"
}

variable "chart_repo" {
  description = "Helm chart repository"
  type        = string
  default     = "https://itzg.github.io/minecraft-server-charts/"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "minecraft"
}

variable "chart_version" {
  description = "Helm chart version"
  type        = string
  default     = "4.26.3"
}

variable "values_file_path" {
  description = "Path to the values.yaml file for the Helm chart"
  type        = string
  default     = ""
}

variable "wait" {
  description = "Whether to wait for resources to be created"
  type        = bool
  default     = true
}

variable "image_repository" {
  description = "Docker image repository"
  type        = string
  default     = "itzg/minecraft-server"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "resources_limits_memory" {
  description = "Memory limits"
  type        = string
  default     = "10G"
}

variable "resources_limits_cpu" {
  description = "CPU limits"
  type        = string
  default     = "6000m"
}

variable "resources_requests_memory" {
  description = "Memory requests"
  type        = string
  default     = "10G"
}

variable "resources_requests_cpu" {
  description = "CPU requests"
  type        = string
  default     = "6000m"
}

variable "minecraft_type" {
  description = "Type of Minecraft server"
  type        = string
  default     = "MODRINTH"
}

variable "minecraft_version" {
  description = "Minecraft version"
  type        = string
  default     = "1.21.5"
}

variable "minecraft_memory" {
  description = "Memory allocation for Minecraft"
  type        = string
  default     = "1024M"
}

variable "difficulty" {
  description = "Game difficulty"
  type        = string
  default     = "easy"
}

variable "gamemode" {
  description = "Game mode"
  type        = string
  default     = "survival"
}

variable "motd" {
  description = "Message of the day"
  type        = string
  default     = "Welcome to the GoonLag MC Server"
}

variable "level_type" {
  description = "World generation type"
  type        = string
  default     = "DEFAULT"
}

variable "level" {
  description = "World name"
  type        = string
  default     = "world"
}

variable "enable_rcon" {
  description = "Whether to enable RCON"
  type        = bool
  default     = false
}

variable "cf_api_key_secret_name" {
  description = "Name of the secret containing the CurseForge API key"
  type        = string
  default     = "minecraft-server-curseforge"
}

variable "cf_api_key_secret_key" {
  description = "Key in the secret for the CurseForge API key"
  type        = string
  default     = "cf-api-key"
}

variable "cf_parallel_downloads" {
  description = "Number of parallel downloads for CurseForge"
  type        = string
  default     = "4"
}

variable "enable_autopause" {
  description = "Whether to enable auto-pausing the server when no players are online"
  type        = bool
  default     = false
}

variable "modrinth_modpack" {
  description = "Modrinth modpack to use when TYPE is MODRINTH"
  type        = string
  default     = "vanilla-perfected"
}

variable "extra_env_vars" {
  description = "Additional environment variables"
  type        = map(string)
  default     = {}
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "NodePort"
}

variable "node_port" {
  description = "NodePort value for the service"
  type        = number
  default     = 30013
} 