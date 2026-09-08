# Evolution 02: Destination Service

After the first manual deployment phase, remote endpoint configuration moved toward SAP Destination Service.

## Motivation

Hard-coded endpoint configuration couples application artifacts to environment topology. Destination Service provides a BTP-native configuration boundary for remote HTTP targets.

## Result

The BTP backend resolved destinations programmatically and used SAP Cloud SDK HTTP execution for downstream calls.

Verified paths represented by this phase:

- `/destination-check` for the remote AKS-facing probe endpoint.
- `/onprem-check` for the standalone SAP Cloud Connector lab path.
