# ADR 0006: Infrastructure vs Workload Lifecycle

## Status

Accepted

## Context

Terraform is well suited for Azure infrastructure, while Kubernetes manifests and scripts are better suited for workload deployment cadence. Coupling everything to Terraform can create provider-ordering problems during cluster teardown.

## Decision

Keep Azure infrastructure lifecycle under Terraform and Kubernetes workload lifecycle under manifests/scripts. Use orchestration to connect Terraform outputs to Kubernetes resources after infrastructure creation.

## Consequences

AKS can be destroyed cleanly without Terraform trying to manage in-cluster objects through a disappearing API server. The trade-off is that rebuild automation must explicitly render and verify workload manifests.

## Alternatives Considered

Managing all Kubernetes resources through Terraform was rejected for this lab because it would couple workload reconciliation to cluster lifecycle too tightly.
