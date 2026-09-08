# ADR 0005: MinIO As S3-Compatible Terraform Remote State

## Status

Accepted for Lab

## Context

Terraform state contains sensitive resource metadata and must not be committed to Git. The lab needed remote state semantics without publishing backend implementation details.

## Decision

Use a MinIO S3-compatible backend for Terraform remote state. Keep backend names, endpoints and credentials outside the public repository.

## Consequences

State is centralized and excluded from Git. The trade-off is that backend bootstrap and credentials remain an operational dependency outside this repository.

## Alternatives Considered

Local state was rejected for shared lifecycle work and public portfolio safety. Committing state was never acceptable.
