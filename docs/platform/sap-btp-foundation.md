# SAP BTP Foundation

The SAP BTP layer used Cloud Foundry for the application runtime and service binding model. The implementation was verified in a SAP BTP Trial environment.

## Implemented Components

| Component | Role in the lab |
| --- | --- |
| Global account / subaccount | Conceptual account hierarchy; identifiers are intentionally omitted. |
| Cloud Foundry org / space | Runtime grouping for applications, services and routes. |
| Backend application | Implemented the Destination-backed call to the remote AKS-facing endpoint. |
| AppRouter | Authenticated browser entry point. |
| XSUAA | Authentication, Read scope and Viewer-style authorization role collection. |
| Destination Service | Externalized remote HTTPS endpoint configuration. |
| Connectivity Service | Used with SAP Cloud Connector in the standalone on-prem-style lab. |
| Service bindings | Connected applications to platform services. |
| Terraform | Brought selected BTP resources, including role collection management, under explicit ownership. |

## Provider Boundary

SAP BTP resources span account/subaccount concerns and Cloud Foundry runtime concerns. The implementation used SAP/btp and cloudfoundry/cloudfoundry provider responsibilities where appropriate instead of forcing all resources through one abstraction.

Existing resources were progressively adopted into Terraform rather than blindly recreated. Provider import and read-back limitations were documented as engineering constraints.

The sanitized reference implementation includes the files that matter for review: [server.js](../../reference-implementation/sap-btp/application/server.js), [xs-app.json](../../reference-implementation/sap-btp/approuter/xs-app.json), [xs-security.json](../../reference-implementation/sap-btp/terraform/xs-security.json), and Terraform resources for apps, services, routes, bindings, destinations and role assignment.

## References

- [SAP BTP Connectivity](https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/destinations)
- [SAP Application Router routes and destinations](https://help.sap.com/docs/btp/sap-business-technology-platform/application-routes-and-destinations)
- [Terraform Registry: SAP BTP provider](https://registry.terraform.io/providers/SAP/btp/latest)
- [Terraform Registry: Cloud Foundry provider](https://registry.terraform.io/providers/cloudfoundry/cloudfoundry/latest)
