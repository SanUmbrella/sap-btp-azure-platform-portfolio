# Sanitized Reference Implementation

This directory contains sanitized source derived from locally available working lab implementation files where those files were safe to publish. It is not a complete deployable environment and intentionally omits live identifiers, credentials, backend state, endpoints and private operational scripts.

## Structure

| Path | Purpose |
| --- | --- |
| `sap-btp/application` | Node.js backend with XSUAA scope checks, Destination-backed calls and correlation-ID propagation. |
| `sap-btp/approuter` | SAP AppRouter reference configuration. |
| `sap-btp/terraform` | Sanitized Cloud Foundry and BTP Terraform resources. |
| `azure/probe-api` | Go AKS probe API that validates Workload Identity and Key Vault data-plane access. |
| `azure/terraform` | Sanitized AKS workload identity, Key Vault and tunnel-supporting infrastructure shape. |
| `azure/kubernetes` | Representative AKS ServiceAccount and workload manifests. |

## Sanitization Boundary

The code uses placeholders and variables for all environment-specific values. Do not add real BTP subaccount IDs, Cloud Foundry org names, Azure IDs, remote-state endpoints, public routes, tunnel tokens or credentials to this directory.

## Intended Use

Use this implementation as a code-reading companion to the architecture documentation. It demonstrates the engineering model: AppRouter and XSUAA on BTP, Destination Service for endpoint externalization, AKS Workload Identity for Azure Key Vault data-plane access, and explicit lifecycle separation between infrastructure and workload deployment.

Some historical artifacts remain intentionally excluded, including compiled Go binaries, Terraform plans, Terraform state, `.terraform` directories, backend credential files, real backend configuration, kubeconfigs, tunnel tokens and environment-specific manifests containing live identifiers.
