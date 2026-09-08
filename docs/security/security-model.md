# Security Model

This public repository describes security-sensitive architecture without publishing live identifiers, credentials, state or private environment details.

## Trust Boundaries

| Boundary | Responsibility |
| --- | --- |
| User / browser | Initiates the request and carries user session context. |
| SAP BTP authentication boundary | AppRouter and XSUAA establish authenticated access. |
| BTP application/service binding boundary | Backend application consumes bound platform services. |
| Internet/tunnel connectivity boundary | HTTPS edge and Cloudflare Tunnel deliver application inbound traffic. |
| AKS cluster boundary | Kubernetes schedules the probe API and cloudflared connectors. |
| Kubernetes ServiceAccount boundary | Pod identity is represented by a ServiceAccount subject. |
| Microsoft Entra identity boundary | Federated token exchange issues managed identity access. |
| Azure Key Vault data-plane boundary | RBAC authorizes the secret-read operation. |
| Terraform state boundary | Remote state is protected outside Git. |
| Secret-management boundary | Runtime material is resolved from external secret handling. |

## Least Privilege

The managed identity was granted narrowly scoped Key Vault access through Azure RBAC. BTP authorization was modeled separately through XSUAA scopes and role collections.

## Workload Identity vs Static Secret

Workload Identity is preferable here because the AKS workload receives short-lived federated access through Microsoft Entra instead of storing a long-lived Azure application secret. This reduces credential rotation burden and limits the blast radius of pod or repository exposure.

## Authentication vs Authorization

Authentication proves identity. Authorization grants permission. XSUAA authentication and BTP role collections controlled access to the SAP application path; Azure RBAC controlled what the managed identity could do against Key Vault.

## Repository Controls

The repository includes a validation script and security-conscious `.gitignore` to reduce accidental publication of state, plans, credentials, private keys, kubeconfigs and environment files.
