# Verification Runbook

This runbook uses placeholders only. Replace them with environment-specific values outside the public repository.

## Checks

| Check | Sanitized command or action | Expected result |
| --- | --- | --- |
| BTP auth | Open the protected AppRouter route. | User is authenticated and authorized. |
| Destination configuration | Inspect the configured destination in BTP tooling. | Remote endpoint and authentication mode are present. |
| AKS readiness | `kubectl get nodes` | Nodes are Ready. |
| Probe workload | `kubectl get pods -l app=aks-probe-api` | Probe pod is Running. |
| Workload Identity | Inspect ServiceAccount annotations. | Client ID matches Terraform output. |
| Key Vault access | Call probe API health/secret-check route. | `keyVaultAccess = true`. |
| Tunnel health | Inspect cloudflared replicas and tunnel status. | Two replicas are available and connected. |
| E2E correlation | Trigger BTP request with `demo-correlation-id`. | Same ID appears in BTP and AKS logs. |

## Sanitized E2E Probe

```text
curl -H "x-correlation-id: demo-correlation-id" <btp-application-route>/<probe-path>
```

Expected representation:

```json
{
  "status": "ok",
  "service": "aks-probe-api",
  "correlationId": "demo-correlation-id",
  "keyVaultAccess": true
}
```
