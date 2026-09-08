# Provider And API Limitations

Terraform can only detect drift that the underlying platform API or service broker can read back with enough fidelity.

## XSUAA Parameter Read-Back

Observed behavior:

```text
Terraform desired configuration     yes
Terraform create/update             yes
Terraform destroy/recreate          yes
full remote parameter drift detect  no
```

For XSUAA, the service broker did not expose complete instance parameters for full read-back comparison. This is not presented as a Terraform provider bug. It is an API/service broker limitation that shapes what Terraform can safely prove.

## Role Collection Assignment Import Gap

The `btp_subaccount_role_collection_assignment` resource exists, but import support was not available for the adoption path used in the lab. The selected pattern was:

```text
manual assignment
-> identity/origin/role check
-> Terraform targeted plan
-> manual assignment removal
-> Terraform recreate
-> verification
```

This is documented as an IaC adoption pattern and potential feature-request area, not as a verified provider defect.

## Cloud Foundry Binding Plan Noise

During adoption, the Cloud Foundry provider planned replacement of service credential bindings when the referenced application ID became unknown during plan:

```text
cloudfoundry_app.backend.id
-> known after apply
-> cloudfoundry_service_credential_binding.app
-> ForceNew
-> binding replacement
```

The plan JSON signal was:

```text
replace_paths = [["app"]]
after_unknown.app = true
```

This is a useful upstream investigation candidate if reproduced in a minimal lab against the current provider version.

## `params = null` vs `params = {}`

Another adoption issue involved imported service bindings where state represented absent parameters as `null`, while configuration represented an empty object as `{}`. If the provider treats the difference as replacement-relevant, a no-op plan can become destructive.

This should be reduced to a minimal reproducer before opening a new upstream issue.

## References

- [Cloud Foundry provider releases](https://github.com/cloudfoundry/terraform-provider-cloudfoundry/releases)
- [Cloud Foundry provider PR 237](https://github.com/cloudfoundry/terraform-provider-cloudfoundry/pull/237)
- [Cloud Foundry provider issue 257](https://github.com/cloudfoundry/terraform-provider-cloudfoundry/issues/257)
- [SAP BTP role collection assignment resource](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount_role_collection_assignment)
