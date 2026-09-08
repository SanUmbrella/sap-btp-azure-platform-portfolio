# ADR 0002: Durable Bootstrap vs Disposable Lab

## Status

Accepted for Lab

## Context

Some resources are durable governance or platform foundations. Others are lab resources that can be destroyed and rebuilt for testing, cost control and lifecycle proof.

## Decision

Separate long-lived bootstrap resources from disposable lab resources. Keep AKS, ACR, Key Vault and workload identity components in the disposable lab boundary.

## Consequences

The lab can be torn down without destroying every supporting dependency. AKS worker compute can be removed when not in use. The trade-off is that orchestration must reconnect dynamic outputs after rebuild.

## Alternatives Considered

A single Terraform state was simpler, but it would make teardown riskier and blur durable versus disposable ownership.
