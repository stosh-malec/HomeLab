variable "name" {
  description = "Name of the Satisfactory server"
  type        = string
  default     = "satisfactory-server"
}

variable "namespace" {
  description = "Kubernetes namespace to deploy into"
  type        = string
  default     = "games"
}

variable "create_persistent_volume_claim" {
  description = "Whether to create a persistent volume claim"
  type        = bool
  default     = false  # Default to false since we're likely importing
}

variable "persistent_volume_claim_name" {
  description = "Name of the persistent volume claim"
  type        = string
  default     = "satisfactory-files"
}

variable "storage_size" {
  description = "Size of the persistent volume"
  type        = string
  default     = "20Gi"
}

variable "storage_class_name" {
  description = "Storage class name"
  type        = string
  default     = "longhorn-static"
}

variable "chart_path" {
  description = "Path to the Helm chart"
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
  default     = "wolveix/satisfactory-server"
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
  default     = "latest"
}

variable "image_pull_policy" {
  description = "Docker image pull policy"
  type        = string
  default     = "IfNotPresent"
}

variable "persistence_mount_path" {
  description = "Mount path for the persistent volume"
  type        = string
  default     = "/satisfactory/config"
}

variable "max_players" {
  description = "Maximum number of players"
  type        = number
  default     = 8
}

variable "pgid" {
  description = "Process group ID"
  type        = number
  default     = 1000
}

variable "puid" {
  description = "Process user ID"
  type        = number
  default     = 1000
}

variable "steambeta" {
  description = "Whether to use Steam beta"
  type        = bool
  default     = true
}

variable "debug" {
  description = "Enable debug mode"
  type        = string
  default     = "false"
}

variable "skip_update" {
  description = "Skip updates on startup"
  type        = string
  default     = "false"
}

variable "service_type" {
  description = "Kubernetes service type"
  type        = string
  default     = "LoadBalancer"
} 