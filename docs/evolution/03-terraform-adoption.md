# Evolution 03: Terraform Adoption

Terraform ownership was introduced progressively rather than by blindly recreating existing BTP and Cloud Foundry resources.

## Migration Shape

```text
manual resource
-> inspect identity and dependencies
-> import when supported
-> targeted plan
-> inspect plan output
-> controlled ownership transfer
-> verify application behavior
```

## Important Cases

- XSUAA lifecycle was managed while accepting service broker read-back limits.
- Role collection management moved under Terraform ownership.
- Role collection assignment adoption required controlled recreation where import was unavailable.
- Cloud Foundry app and binding behavior required plan JSON analysis.

See [Terraform adoption](../engineering/terraform-adoption.md) and [migration failure analysis](../engineering/migration-failure-analysis.md).
