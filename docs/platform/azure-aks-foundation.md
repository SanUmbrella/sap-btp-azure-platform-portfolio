# Azure AKS Foundation

The Azure platform layer was managed with Terraform and split into long-lived bootstrap resources and disposable lab resources.

## Implemented Components

| Component | Role in the lab |
| --- | --- |
| Azure networking | Supported the disposable AKS environment and connectivity experiments. |
| AKS | Hosted the probe API and cloudflared connector replicas. |
| Azure CNI Overlay | Used for AKS networking in the lab. |
| ACR | Stored the probe API container image. |
| Key Vault | Protected the secret-read target used for verification. |
| User-assigned managed identity | Represented the Azure identity used by the AKS workload. |
| Federated identity credential | Bound the Kubernetes ServiceAccount subject to Microsoft Entra. |
| Azure RBAC | Granted narrowly scoped Key Vault data-plane access. |

## Lifecycle

The Azure lab was intentionally disposable. Destroying the lab avoided leaving AKS worker compute running unnecessarily, while the bootstrap boundary preserved resources that should not be recreated for every test cycle.

After rebuild, dynamic outputs such as managed identity client ID and OIDC issuer URL were re-resolved before Kubernetes deployment.

## References

- [Microsoft Learn: AKS](https://learn.microsoft.com/azure/aks/)
- [Microsoft Learn: Azure CNI Overlay](https://learn.microsoft.com/azure/aks/azure-cni-overlay)
- [Microsoft Learn: Key Vault RBAC](https://learn.microsoft.com/azure/key-vault/general/rbac-guide)
