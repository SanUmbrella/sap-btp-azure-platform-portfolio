# Version Context

The public repository distinguishes historical implementation versions from later documentation or validation context.

## Historical Lab Versions

| Component | Version context |
| --- | --- |
| Terraform | `>= 1.15.0` |
| SAP/btp provider | `1.25.0` |
| cloudfoundry/cloudfoundry provider | `1.17.0` |
| hashicorp/azurerm provider | `5.2.0` |
| Node.js | `22.x` for the SAP BTP application and AppRouter source |
| Go | `1.24` for the AKS probe API |

## Documentation Rule

When a future reproducer or example is validated against a newer provider release, document it as:

```text
Originally implemented with X.
Public sanitized example currently validated with Y.
```

Do not rewrite the lab history to claim a newer version was used originally.
