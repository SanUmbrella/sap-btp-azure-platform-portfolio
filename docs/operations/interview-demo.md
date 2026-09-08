# Architecture Walkthrough

This page helps an engineer explain the project quickly in a portfolio review or technical discussion. It is not tied to a specific company or vacancy.

## 30-Second Version

This project documents a verified SAP BTP and Azure platform lab with a sanitized reference implementation. A SAP BTP Cloud Foundry application authenticated through AppRouter and XSUAA, resolved a remote endpoint through Destination Service, called an AKS-hosted Go probe API through Cloudflare Tunnel, and the AKS workload read from Azure Key Vault using Microsoft Entra Workload Identity. Terraform managed the platform lifecycle, and the disposable Azure lab was destroyed and rebuilt successfully.

## 3-Minute Version

1. Problem: prove a secure cross-platform path from SAP BTP to Azure without embedding credentials or hard-coded endpoints in the application.
2. Architecture: browser traffic enters through AppRouter and XSUAA, the BTP backend uses Destination Service, and the final application inbound path reaches AKS through Cloudflare Tunnel.
3. Identity: the AKS pod uses a Kubernetes ServiceAccount, projected OIDC token and Microsoft Entra token exchange to act as a user-assigned managed identity.
4. Connectivity: direct Azure public LoadBalancer ingress was verified earlier, then replaced for the final E2E path by Cloudflare Tunnel to a ClusterIP service. SAP Cloud Connector was separately verified for BTP-to-local/on-prem-style connectivity.
5. Terraform lifecycle: durable bootstrap resources were separated from disposable lab resources. Plans were inspected before apply, including JSON plan inspection with `jq`.
6. IaC adoption: manual resources were progressively migrated to Terraform, including documented provider/API limits and lifecycle workarounds.
7. E2E proof: the same correlation ID was observed in BTP and AKS logs, and the AKS response confirmed Key Vault access.
8. Security trade-offs: the design avoids static Azure client secrets in AKS, keeps remote state credentials and tunnel tokens out of Git, and uses least-privilege Azure RBAC.
9. Future private connectivity pattern: running SAP Cloud Connector in an Azure VNet to expose a private AKS endpoint is a planned architecture exploration, not a verified result.
