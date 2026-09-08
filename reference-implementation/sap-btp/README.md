# SAP BTP Reference Implementation

This folder shows sanitized BTP source derived from locally available lab files. Environment-specific identifiers, generated archives, Terraform state and credentials are intentionally omitted.

## Verified Concepts Represented

- XSUAA credentials discovered from `VCAP_SERVICES`.
- Public `/health` endpoint.
- Protected scope check for application routes.
- Destination-backed HTTP calls through SAP Cloud SDK.
- Destination-backed external call for the AKS-facing probe path.
- Connectivity Service / SAP Cloud Connector style call for the standalone on-prem lab path.
- Azure AKS probe call with correlation-ID propagation.
- Stable route and service lifecycle owned through Terraform.

## Not Included

This directory does not include manual `cf push` manifests, service keys, live BTP routes, real subaccount values, build archives, backend configuration or Terraform state. The manual manifest phase is documented separately in [evolution docs](../../docs/evolution/01-manual-cf-push.md).
