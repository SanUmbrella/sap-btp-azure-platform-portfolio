# Azure Reference Implementation

This folder contains sanitized Azure source derived from locally available lab files for the AKS, Workload Identity, ACR, Key Vault data-plane access and Cloudflare Tunnel pattern.

The files omit real subscription IDs, tenant IDs, resource group names, Key Vault names, ACR names, tunnel tokens, kubeconfigs, compiled binaries, Terraform state and saved plans.

The Go probe uses `NewListSecretPropertiesPager` to verify Key Vault data-plane authorization. It does not retrieve a secret value.
