# Terraform Adoption

The lab did not start as a perfect greenfield Terraform project. Some SAP BTP and Cloud Foundry resources existed manually and were brought under Terraform ownership progressively.

## Adoption Pattern

```text
existing manually managed resource
-> identity and ownership check
-> Terraform import where supported
-> targeted plan
-> plan JSON inspection
-> controlled migration action
-> post-migration verification
```

This is different from blindly recreating resources. The migration goal was to preserve working application behavior while gradually increasing infrastructure-as-code ownership.

## Verified Adoption Cases

| Case | Strategy | Result |
| --- | --- | --- |
| XSUAA service instance | Represent desired configuration while accepting service broker read-back limits. | Terraform managed lifecycle, but full remote parameter drift detection was not available. |
| Role collection management | Bring role collection under Terraform and handle assignment import gap deliberately. | Role collection ownership improved; assignment migration required controlled recreation. |
| Destination configuration | Move endpoint configuration to Destination Service resources. | Application code no longer hard-coded the AKS-facing endpoint. |
| Stable routes | Replace manual/random route assumptions with deterministic Terraform-managed routes. | AppRouter redirect and backend route behavior became reviewable. |

## Why This Matters

IaC adoption is often messier than initial creation. Existing resources have identity, history and users. The implementation treated provider behavior, platform API limits and migration ordering as first-class engineering concerns.
