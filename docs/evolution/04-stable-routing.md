# Evolution 04: Stable Routing

The final BTP model used stable Terraform-managed routes rather than random-route deployment.

## Why Stable Routes Matter

Stable routes make AppRouter configuration, redirect behavior, operational verification and documentation easier to reason about. They also avoid carrying old manual deployment assumptions into Terraform-managed infrastructure.

## Final Shape

```text
Terraform-managed route
-> AppRouter destination to backend
-> BTP backend resolves Destination Service target
-> downstream call verified by correlation ID
```

The public reference implementation represents this final model.
