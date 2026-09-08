# Public Repository Sanitization

This repository is intentionally sanitized for public sharing.

## Removed Information Classes

The public version omits:

- Azure subscription, tenant, client, managed identity and resource identifiers.
- SAP BTP global account, subaccount, Cloud Foundry org and space identifiers.
- Service keys, XSUAA values, Destination credentials and Cloud Connector credentials.
- Public and private IP addresses, internal DNS names and private endpoint names.
- Terraform backend names, state files, saved plans and backend credentials.
- MinIO access details and bucket names.
- Cloudflare account details and Tunnel tokens.
- Infisical credentials and runtime secret material.
- Key Vault, ACR and resource group names from the lab.
- Kubernetes kubeconfigs, certificates, keys and screenshots containing environment details.

## Public Placeholder Philosophy

Documentation uses placeholders such as `<azure-subscription>`, `<btp-subaccount>`, `<managed-identity-client-id>`, `<key-vault-name>` and `<public-endpoint>`. These placeholders describe shape and responsibility without leaking real values.

## Evidence Handling

The evidence documents use sanitized representations of observed results. They do not publish raw screenshots or logs because those artifacts can contain private platform identifiers.
