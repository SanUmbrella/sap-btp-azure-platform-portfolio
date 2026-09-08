variable "location" {
  type = string
}

variable "resource_group_name" {
  description = "Base resource group prefix supplied outside this public repository."
  type        = string
}

variable "cluster_name" {
  description = "AKS cluster name supplied outside this public repository."
  type        = string
}

variable "acr_name" {
  description = "ACR name supplied outside this public repository."
  type        = string
}

variable "key_vault_name" {
  description = "Key Vault name supplied outside this public repository."
  type        = string
}

variable "vnet_address_space" {
  description = "Main VNet address space supplied by the environment-specific stack."
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "Subnet prefixes supplied by the environment-specific stack."

  type = object({
    aks_system        = list(string)
    aks_user          = list(string)
    private_endpoints = list(string)
    platform          = list(string)
  })
}

variable "workload_namespace" {
  type    = string
  default = "platform-lab"
}

variable "workload_service_account" {
  type    = string
  default = "kv-reader"
}

variable "cloudflare_tunnel_secret_name" {
  description = "Name of the Kubernetes secret materialized at runtime outside Terraform."
  type        = string
  default     = "tunnel-token"
}

variable "common_tags" {
  description = "Non-sensitive tags supplied by the environment-specific stack."
  type        = map(string)
  default = {
    environment = "lab"
    managed-by  = "terraform"
    project     = "sap-btp-azure-platform"
  }
}
