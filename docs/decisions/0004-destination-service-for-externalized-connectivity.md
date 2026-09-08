# ADR 0004: Destination Service For Externalized Connectivity

## Status

Accepted

## Context

The BTP backend needed to call a remote endpoint. Hard-coding endpoint configuration in application code would couple deployment topology to the app artifact.

## Decision

Use SAP Destination Service to externalize remote endpoint configuration. The application resolves the destination at runtime and sends the request with correlation context.

## Consequences

Endpoint changes can be managed as platform configuration. The trade-off is that application diagnostics must include destination resolution failures separately from downstream HTTP failures.

## Alternatives Considered

Hard-coded URLs were rejected because they weaken portability. Environment variables alone were considered but do not provide the same BTP-native destination management model.
