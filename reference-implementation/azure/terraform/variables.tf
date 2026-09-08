variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "key_vault_name" {
  type = string
}

variable "workload_namespace" {
  type    = string
  default = "platform-lab"
}

variable "workload_service_account" {
  type    = string
  default = "aks-probe-api"
}

variable "cloudflare_tunnel_secret_name" {
  description = "Name of the Kubernetes secret materialized at runtime outside Terraform."
  type        = string
  default     = "cloudflared-token"
}
