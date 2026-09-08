# Sanitized Reference Implementation

This directory contains representative sanitized implementation code derived from the verified lab shape. It is not a complete deployable environment and intentionally omits live identifiers, credentials, backend state, endpoints and private operational scripts.

## Structure

| Path | Purpose |
| --- | --- |
| `sap-btp/app` | Node.js backend with XSUAA scope checks and Destination Service calls. |
| `sap-btp/approuter` | SAP AppRouter reference configuration. |
| `sap-btp/terraform` | Sanitized Cloud Foundry and BTP Terraform resources. |
| `azure/terraform` | Sanitized AKS workload identity, Key Vault and tunnel-supporting infrastructure shape. |
| `azure/kubernetes` | Representative AKS ServiceAccount and workload manifests. |

## Sanitization Boundary

The code uses placeholders and variables for all environment-specific values. Do not add real BTP subaccount IDs, Cloud Foundry org names, Azure IDs, remote-state endpoints, public routes, tunnel tokens or credentials to this directory.

## Intended Use

Use this implementation as a code-reading companion to the architecture documentation. It demonstrates the engineering model: AppRouter and XSUAA on BTP, Destination Service for endpoint externalization, AKS Workload Identity for Azure access, and explicit lifecycle separation between infrastructure and workload deployment.
