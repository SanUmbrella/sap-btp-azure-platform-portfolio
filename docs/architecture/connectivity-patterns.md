# Connectivity Patterns

The lab evaluated multiple connectivity patterns. Only the implemented flows are marked as verified.

| Pattern | Status | Summary |
| --- | --- | --- |
| Direct Azure public LoadBalancer | Verified earlier variant | AKS exposed the application through a public Azure LoadBalancer during an earlier stage. |
| Cloudflare Tunnel to AKS ClusterIP | Verified final E2E variant | cloudflared replicas ran in AKS and connected an internal ClusterIP service to Cloudflare. |
| SAP Cloud Connector to local/on-prem-style API | Verified standalone BTP connectivity lab | SAP BTP used Destination and Connectivity services through Cloud Connector to reach a local mock API. |
| SAP Cloud Connector in Azure VNet to private AKS | Planned / not implemented | Architecture exploration for exposing a private Azure service through SAP-native connectivity. |

## Cloudflare Tunnel Pattern

Cloudflare Tunnel was used as an application inbound pattern. The application workload used a Kubernetes ClusterIP service, while cloudflared replicas established outbound tunnel connections. This avoided requiring a public Azure LoadBalancer for the application endpoint in the final E2E variant.

## SAP Cloud Connector Pattern

The verified SAP Cloud Connector lab was:

```text
SAP BTP
-> Destination / Connectivity
-> SAP Cloud Connector
-> local/on-prem-style mock API
```

The future architecture exploration is:

```text
SAP BTP
-> Destination
-> Connectivity Service
-> SAP Cloud Connector in Azure VNet
-> private Azure / AKS service
```

That second pattern is interesting because SAP Cloud Connector is SAP-native for controlled exposure of private targets, but it was not implemented as the final AKS path in this lab.

## References

- [SAP BTP Connectivity](https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/destinations)
- [SAP Connectivity Service consumption](https://help.sap.com/docs/connectivity/sap-btp-connectivity-cf/313b215066a8400db461b311e01bd99b.html)
- [Cloudflare Tunnel on Kubernetes](https://developers.cloudflare.com/tunnel/deployment-guides/kubernetes/)
