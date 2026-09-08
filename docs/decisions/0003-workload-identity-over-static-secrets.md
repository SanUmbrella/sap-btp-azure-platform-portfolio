# ADR 0003: Federated Workload Identity Over Static Secrets

## Status

Accepted

## Context

The AKS workload needed access to Azure Key Vault. A static Azure client secret would require secure injection, rotation and leak response.

## Decision

Use AKS Workload Identity with Microsoft Entra federation. Bind a Kubernetes ServiceAccount subject to a user-assigned managed identity and authorize that identity with Azure RBAC.

## Consequences

The workload uses token exchange instead of a long-lived client secret. This reduces secret handling inside Kubernetes. The trade-off is that OIDC issuer, ServiceAccount subject and managed identity configuration must stay aligned.

## Alternatives Considered

Static client secrets were rejected due to credential exposure and rotation burden. Broad node-level permissions were rejected because they would over-authorize the workload.
