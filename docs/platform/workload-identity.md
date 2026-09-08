# Workload Identity

The AKS workload used Microsoft Entra Workload Identity to access Azure Key Vault without a static Azure client secret.

## Verified Chain

```text
AKS pod
-> Kubernetes ServiceAccount
-> projected OIDC token
-> Microsoft Entra token exchange
-> user-assigned managed identity
-> Azure RBAC
-> Azure Key Vault
```

## Rebuild Consideration

After the disposable Azure lab was rebuilt, identity values were dynamically resolved again. The Kubernetes ServiceAccount annotation was rendered from Terraform output, and the rendered client ID was checked against the managed identity output before retesting the application.

This avoided a common rebuild failure mode: keeping a stale client ID in Kubernetes after the underlying identity resource has been recreated.

## References

- [Microsoft Learn: AKS Workload Identity](https://learn.microsoft.com/azure/aks/workload-identity-overview)
- [Terraform Registry: azurerm_federated_identity_credential](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/federated_identity_credential)
