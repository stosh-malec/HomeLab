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