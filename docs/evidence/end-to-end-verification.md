# End-to-End Verification

This page documents the verification methodology using sanitized examples. The examples are representations of observed lab results and do not contain live environment identifiers.

## Verification Method

1. Authenticate through SAP AppRouter and XSUAA.
2. Trigger the BTP backend path that consumes Destination Service.
3. Send a request with `correlationId = demo-correlation-id`.
4. Confirm the BTP backend logged the same correlation ID.
5. Confirm the AKS probe API logged the same correlation ID.
6. Confirm the AKS response returned `keyVaultAccess = true`.

## Sanitized Response

```json
{
  "status": "ok",
  "service": "aks-probe-api",
  "correlationId": "demo-correlation-id",
  "keyVaultAccess": true
}
```

## Sanitized Log Evidence

SAP BTP backend log representation:

```text
level=info component=btp-backend event=outbound-request correlationId=demo-correlation-id destination=<destination-name>
level=info component=btp-backend event=downstream-response correlationId=demo-correlation-id status=ok
```

AKS probe API log representation:

```text
level=info component=aks-probe-api event=request-received correlationId=demo-correlation-id
level=info component=aks-probe-api event=key-vault-check correlationId=demo-correlation-id keyVaultAccess=true
```

## Why This Proves The Path

The matching correlation ID at both the SAP BTP backend and the AKS probe API shows that the request crossed the BTP application layer, destination resolution, HTTPS edge, tunnel, and AKS service boundary. The Key Vault access result shows the request continued into the AKS workload identity flow rather than stopping at a connectivity intermediary.

The evidence does not claim that screenshots or raw logs are published. They are intentionally omitted from this public repository because live logs can contain environment identifiers.
