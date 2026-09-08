# ADR 0009: Plan-First Destroy/Rebuild

## Status

Accepted

## Context

Destroying and rebuilding a lab with AKS, ACR, Key Vault and workload identity can remove many resources at once. Mistakes are easier to catch before apply than after.

## Decision

Use a plan-first workflow for both destroy and rebuild. Inspect saved Terraform plans and JSON plan output before apply, then verify cloud-side state and application behavior.

## Consequences

The lab produced clear lifecycle evidence: destroy showed 0 added, 0 changed and 24 destroyed; rebuild showed 24 added, 0 changed and 0 destroyed. The trade-off is slower iteration, but the workflow is safer and more explainable.

## Alternatives Considered

Blind apply automation was rejected because it hides risk and weakens reviewability.
