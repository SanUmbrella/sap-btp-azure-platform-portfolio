# Terraform State

Terraform state was treated as a security-sensitive operational boundary. SAP and Azure states were separated, and Azure infrastructure was split into durable bootstrap and disposable lab lifecycles.

## State Boundaries

| Boundary | Purpose |
| --- | --- |
| SAP state | BTP and Cloud Foundry platform resources under Terraform ownership. |
| Azure bootstrap state | Durable platform/governance resources that should survive lab teardown. |
| Azure lab state | Disposable networking, AKS, ACR, Key Vault and workload identity resources. |

Remote state used an S3-compatible MinIO backend. Backend credentials were project-scoped and not committed to Git.

## Plan-First Workflow

```text
change
-> terraform fmt / validate
-> terraform plan
-> inspect JSON plan with jq
-> review
-> apply
-> verification
```

Saved Terraform plans were inspected before apply. Terraform JSON plan output and `jq` were used to inspect intended operations.

## Lifecycle Evidence

The disposable Azure lab was destroyed and rebuilt.

| Operation | Observed summary |
| --- | --- |
| Destroy | 0 added, 0 changed, 24 destroyed |
| Rebuild | 24 added, 0 changed, 0 destroyed |

After rebuild, Kubernetes workload identity values were dynamically resolved rather than relying on stale client IDs.

## References

- [Terraform S3 backend](https://developer.hashicorp.com/terraform/language/backend/s3)
- [Terraform JSON plan representation](https://developer.hashicorp.com/terraform/internals/json-format)
