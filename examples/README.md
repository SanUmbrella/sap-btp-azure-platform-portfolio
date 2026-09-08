# Examples

Representative sanitized patterns, not a complete deployable environment.

These files show the shape of selected implementation patterns while intentionally avoiding real account identifiers, endpoint names, state configuration or credentials.

## Files

- [btp-destination.tf](terraform/btp-destination.tf): representative SAP BTP generic destination pattern.
- [workload-identity.tf](terraform/workload-identity.tf): representative Azure managed identity, federated identity credential and Key Vault RBAC pattern.
- [workload-identity-serviceaccount.yaml](kubernetes/workload-identity-serviceaccount.yaml): representative Kubernetes ServiceAccount annotation for Azure Workload Identity.
