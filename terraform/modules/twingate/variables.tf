variable "namespace" {
  description = "Kubernetes namespace for Twingate"
  type        = string
  default     = "twingate"
}

variable "network" {
  description = "Twingate network name"
  type        = string
}

variable "api_token" {
  description = "Twingate API token with Read, Write & Provision permissions"
  type        = string
  sensitive   = true
}

variable "remote_network_name" {
  description = "Name for the Twingate remote network"
  type        = string
  default     = "homelab"
}

variable "connector_image_tag" {
  description = "Docker image tag for Twingate connector (use 'latest' for auto-update)"
  type        = string
  default     = "latest"
}

variable "node1_selector" {
  description = "Node selector for connector 1"
  type        = map(string)
  default     = {}
}

variable "node2_selector" {
  description = "Node selector for connector 2"
  type        = map(string)
  default     = {}
}