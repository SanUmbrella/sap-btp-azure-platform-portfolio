# Upstream Opportunities

This page separates portfolio documentation from potential provider contributions.

## Cloud Foundry Provider

The Cloud Foundry provider is the appropriate upstream for issues involving `cloudfoundry_app` and `cloudfoundry_service_credential_binding` behavior.

Potential investigation:

```text
Imported Cloud Foundry app or binding
-> no HCL change
-> terraform plan
-> app ID marked known after apply
-> service credential binding replacement planned
```

Related historical references:

- [PR 237: inconsistent apply with app and service credential binding](https://github.com/cloudfoundry/terraform-provider-cloudfoundry/pull/237)
- [Issue 257: service bindings that lack params](https://github.com/cloudfoundry/terraform-provider-cloudfoundry/issues/257)

As of September 8, 2026, the Cloud Foundry provider releases page lists `v1.18.0` as latest. The lab observation was made with `v1.17.0`, so a bug report should first reproduce or disprove the behavior against the current provider version.

## Minimal Reproducer Shape

```text
cf-provider-reproducer/
├── README.md
├── versions.tf
└── main.tf
```

The reproducer should prove:

1. Resource creation succeeds.
2. A second plan with no HCL change still wants replacement.
3. `terraform show -json` exposes `replace_paths` and `after_unknown` evidence.

## SAP BTP Provider

The SAP BTP provider is the appropriate upstream for BTP account/subaccount resource behavior. The role collection assignment import gap is better framed as a feature request than a bug unless current documentation says import should work.

Do not open an upstream issue just to have a public contribution. A useful contribution should include current-version behavior, a minimal reproducer or documentation improvement, and a precise statement of expected versus observed behavior.

## References

- [Cloud Foundry provider contributing guide](https://github.com/cloudfoundry/terraform-provider-cloudfoundry/blob/main/CONTRIBUTING.md)
- [SAP BTP provider](https://registry.terraform.io/providers/SAP/btp/latest)
- [SAP BTP provider repository](https://github.com/SAP/terraform-provider-btp)
