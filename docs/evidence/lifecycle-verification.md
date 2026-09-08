# Lifecycle Verification

The disposable Azure lab was destroyed and rebuilt to validate lifecycle assumptions and avoid leaving AKS worker compute running unnecessarily.

## Destroy Verification

The workflow inspected Terraform state, generated a destroy plan, reviewed the plan output, and applied the destroy only after confirming the intended disposable resources.

Observed sanitized summary:

```text
0 added
0 changed
24 destroyed
```

After destroy, cloud-side validation confirmed that the disposable lab resources were no longer present.

## Rebuild Verification

The rebuild generated and reviewed a new plan for the disposable lab stack.

Observed sanitized summary:

```text
24 added
0 changed
0 destroyed
```

After rebuild, the Kubernetes deployment process re-resolved identity outputs instead of reusing stale values:

- AKS OIDC issuer URL was read from fresh Terraform output.
- User-assigned managed identity client ID was read from fresh Terraform output.
- Kubernetes ServiceAccount was recreated with the current client ID annotation.
- The rendered ServiceAccount client ID was checked against Terraform output.
- The probe workload was redeployed and retested.

## Retest

The rebuilt lab passed the workload identity and E2E tests again, including the SAP BTP -> Cloudflare -> AKS -> Key Vault path.
