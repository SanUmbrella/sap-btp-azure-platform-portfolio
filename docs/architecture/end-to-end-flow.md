# End-to-End Flow

The central verified request flow connected SAP BTP to an Azure-hosted AKS workload and then to Azure Key Vault through workload identity federation.

```mermaid
sequenceDiagram
  participant User as User / Browser
  participant Router as SAP AppRouter
  participant XSUAA as XSUAA
  participant BTP as BTP Backend
  participant Dest as Destination Service
  participant Tunnel as Cloudflare Tunnel
  participant AKS as AKS Probe API
  participant Entra as Microsoft Entra ID
  participant KV as Azure Key Vault

  User->>Router: Open protected app
  Router->>XSUAA: Authenticate and authorize
  Router->>BTP: Forward authorized request
  BTP->>Dest: Resolve externalized endpoint
  BTP->>Tunnel: HTTPS request with correlation ID
  Tunnel->>AKS: Forward to internal service
  AKS->>Entra: Exchange projected OIDC token
  Entra-->>AKS: Managed identity token
  AKS->>KV: Read secret with RBAC authorization
  KV-->>AKS: Secret read permitted
  AKS-->>BTP: Sanitized status response
  BTP-->>User: End-to-end result
```

## Verification Signal

The same correlation ID was observed at the SAP BTP backend and at the AKS probe API. The AKS response also returned `keyVaultAccess = true`, which confirmed that the flow did not stop at an intermediary gateway or tunnel layer.

Sanitized representation:

```json
{
  "status": "ok",
  "service": "aks-probe-api",
  "correlationId": "demo-correlation-id",
  "keyVaultAccess": true
}
```

## Important Nuance

Cloudflare Tunnel was used for application inbound connectivity to AKS. It should not be described as removing all Azure public networking needs. The AKS cluster can still require outbound internet access for image pulls, control-plane interactions, package retrieval, logging, or other egress-dependent operations depending on the deployed configuration.
