# Platform Overview

This repository describes a sanitized public representation of a verified SAP BTP and Microsoft Azure platform lab. The implementation emphasized explicit trust boundaries, externalized connectivity, federated identity, and repeatable lifecycle operations.

## Verified Architecture

The verified end-to-end path was:

```text
User
-> SAP AppRouter
-> XSUAA
-> SAP BTP Cloud Foundry backend
-> Destination Service
-> HTTPS
-> Cloudflare edge
-> Cloudflare Tunnel
-> cloudflared connectors in AKS
-> Kubernetes ClusterIP service
-> AKS probe API
-> Kubernetes ServiceAccount
-> AKS OIDC issuer
-> Microsoft Entra workload identity federation
-> user-assigned managed identity
-> Azure RBAC
-> Azure Key Vault
```

The implementation verified that a request originating through SAP BTP reached the AKS workload and that the AKS workload successfully read from Azure Key Vault.

## Major Boundaries

| Boundary | Responsibility |
| --- | --- |
| SAP BTP application boundary | AppRouter, XSUAA, backend application, service bindings and destinations. |
| Connectivity boundary | Destination-backed outbound call, HTTPS edge, Cloudflare Tunnel and internal AKS service exposure. |
| AKS workload boundary | Probe API, Kubernetes ServiceAccount, pod identity configuration and internal service routing. |
| Microsoft Entra boundary | OIDC token exchange and managed identity issuance. |
| Azure authorization boundary | RBAC-scoped Key Vault access. |
| Terraform lifecycle boundary | Separate state and ownership for durable bootstrap and disposable lab resources. |

## Lab vs Production

The lab was built and verified with real services, but this repository intentionally omits live identifiers, credentials, private DNS names, Terraform state and private implementation details. Production adoption would require environment-specific hardening, network design, monitoring, policy controls, and formal change management.

## References

- [SAP BTP Connectivity](https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/destinations)
- [Microsoft Learn: AKS Workload Identity](https://learn.microsoft.com/azure/aks/workload-identity-overview)
- [Cloudflare Tunnel on Kubernetes](https://developers.cloudflare.com/tunnel/deployment-guides/kubernetes/)
