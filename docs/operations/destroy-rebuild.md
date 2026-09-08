# Destroy/Rebuild Operations

The lab was operated with controlled deploy-test-destroy cycles. This kept costs bounded and made the lifecycle design observable.

## Philosophy

The durable bootstrap layer remains in place. The disposable Azure lab layer can be destroyed and rebuilt. BTP durable services may remain depending on the exercise and ownership boundary.

The implementation deliberately separates Azure infrastructure lifecycle from Kubernetes workload lifecycle so that AKS destruction does not create provider-ordering dependencies during Terraform teardown.

## Rebuild Checklist

1. Apply or verify the durable bootstrap layer.
2. Plan the disposable lab stack.
3. Inspect the saved plan and JSON plan output.
4. Apply the disposable lab stack.
5. Restore kubeconfig for the rebuilt AKS cluster.
6. Validate nodes and cluster readiness.
7. Resolve fresh workload identity outputs.
8. Render the Kubernetes ServiceAccount from current Terraform output.
9. Validate ServiceAccount client ID agreement.
10. Build and push the probe image to ACR.
11. Deploy the probe workload.
12. Restore cloudflared connector replicas.
13. Run the health test.
14. Run the Key Vault test.
15. Run the SAP BTP E2E test with a correlation ID.

## Why Dynamic Identity Values Matter

Managed identity client IDs, issuer URLs and other generated values must not be assumed across rebuilds. Static values can survive in manifests, scripts or local shell history and cause a rebuilt cluster to authenticate against an old identity configuration.
