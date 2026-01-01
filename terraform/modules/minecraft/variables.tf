variable "namespace" {
  description = "Kubernetes namespace"
  type        = string
}

variable "chart_version" {
  description = "Minecraft Helm chart version"
  type        = string
}

variable "minecraft_version" {
  description = "Minecraft server version"
  type        = string
}

variable "server_type" {
  description = "Minecraft server type"
  type        = string
}

variable "difficulty" {
  description = "Game difficulty"
  type        = string
}

variable "motd" {
  description = "Message of the day"
  type        = string
}

variable "memory_request" {
  description = "Memory request"
  type        = string
}

variable "cpu_request" {
  description = "CPU request"
  type        = string
}

variable "memory_limit" {
  description = "Memory limit"
  type        = string
}

variable "cpu_limit" {
  description = "CPU limit"
  type        = string
}

variable "node_port" {
  description = "NodePort for the service"
  type        = number
}

variable "storage_size" {
  description = "Storage size for PVC"
  type        = string
  default     = "20Gi"
}

variable "storage_class_name" {
  description = "Storage class name"
  type        = string
  default     = "local-path"
}

variable "modpack_type" {
  description = "Modpack type (MODRINTH, CURSEFORGE, etc.)"
  type        = string
  default     = ""
}

variable "modpack_name" {
  description = "Name of the modpack"
  type        = string
  default     = ""
}

variable "modpack_version" {
  description = "Version of the modpack"
  type        = string
  default     = ""
}

variable "backup_enabled" {
  description = "Enable mcbackup sidecar for world backups"
  type        = bool
  default     = false
}

variable "backup_interval" {
  description = "Backup interval (e.g., 24h, 12h)"
  type        = string
  default     = "24h"
}

variable "backup_bucket_name" {
  description = "GCS bucket name for backups"
  type        = string
  default     = ""
}

variable "gcp_service_account_key" {
  description = "GCP service account key JSON for bucket access"
  type        = string
  sensitive   = true
  default     = ""
}