# Application Flow

The application flow was designed to prove cross-platform reachability and identity behavior, not to expose business data.

## Request Path

1. A browser user accessed the SAP AppRouter.
2. XSUAA authenticated and authorized the request.
3. The AppRouter forwarded the request to the BTP backend.
4. The backend resolved the remote endpoint through Destination Service.
5. The backend sent an HTTPS request with a correlation ID.
6. Cloudflare Tunnel delivered the request to the AKS internal service path.
7. The AKS probe API used workload identity to access Key Vault.
8. The probe API returned a sanitized status response.

## Probe API

The AKS probe API was a small Go HTTP service. It propagated and returned a correlation ID and verified Key Vault access through the configured managed identity.

The response intentionally exposed only operational verification fields:

```json
{
  "status": "ok",
  "service": "aks-probe-api",
  "correlationId": "demo-correlation-id",
  "keyVaultAccess": true
}
```
