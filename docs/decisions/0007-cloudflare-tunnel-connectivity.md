# ADR 0007: Cloudflare Tunnel Connectivity

## Status

Accepted for Lab

## Context

An earlier application ingress variant used a direct Azure public LoadBalancer. The final E2E path needed an application inbound pattern that allowed the AKS service to remain internal.

## Decision

Run two cloudflared replicas inside AKS and expose the probe API through Cloudflare Tunnel to an internal Kubernetes ClusterIP service.

## Consequences

The application no longer required its own inbound Azure public LoadBalancer service in the final variant. This does not eliminate all cluster egress requirements, and Cloudflare Tunnel is not an SAP-native replacement for SAP Cloud Connector.

## Alternatives Considered

Keeping the public LoadBalancer was verified earlier but not used for the final E2E path. SAP Cloud Connector to private AKS remains planned architecture exploration.
