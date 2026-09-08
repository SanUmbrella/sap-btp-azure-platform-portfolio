# SAP BTP Reference Implementation

This folder shows the sanitized BTP application, AppRouter and Terraform configuration model.

## Verified Concepts Represented

- XSUAA credentials discovered from `VCAP_SERVICES`.
- Public `/health` endpoint.
- Protected scope check for application routes.
- Destination Service programmatic lookup.
- Destination-backed external call for the AKS-facing probe path.
- Connectivity Service / SAP Cloud Connector style call for the standalone on-prem lab path.
- Stable route and service lifecycle owned through Terraform.

## Not Included

This directory does not include real manifests from the manual `cf push` phase, service keys, live BTP routes, real subaccount values, or Terraform state. The manual manifest phase is documented separately in [evolution docs](../../docs/evolution/01-manual-cf-push.md).
