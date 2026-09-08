# ADR 0008: SAP Cloud Connector As The BTP On-Prem/VPC Connectivity Pattern

## Status

Accepted for Lab

## Context

SAP Cloud Connector is the SAP-native pattern for controlled BTP connectivity to on-premise or VPC-hosted targets. The lab verified BTP connectivity to a local/on-prem-style mock API through Destination and Connectivity services.

## Decision

Document SAP Cloud Connector as a verified standalone BTP connectivity pattern and as a planned future pattern for private Azure/AKS connectivity.

## Consequences

The repository is precise about what was implemented: BTP -> Destination / Connectivity -> Cloud Connector -> local mock API. It does not claim private AKS through Cloud Connector was implemented.

## Alternatives Considered

Using Cloudflare Tunnel for all connectivity language was rejected because it would conflate separate SAP-native and application-inbound patterns.
