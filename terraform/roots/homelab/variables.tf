variable "kube_config_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kube_context" {
  description = "Name of the kubeconfig context to use"
  type        = string
  default     = "home"
} 