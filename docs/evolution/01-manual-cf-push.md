# Evolution 01: Manual Cloud Foundry Push

The lab began with manual Cloud Foundry deployment patterns. This phase is useful as historical context, but it is not the desired final repository state.

## Earlier Shape

```text
cf push
-> manifest-driven deployment
-> random route
-> environment variable points to backend URL
```

## Why It Was Replaced

Manual manifests were useful for proving the application quickly. They were not ideal as the final model because random routes and hard-coded backend URLs conflict with repeatable routing, AppRouter redirect behavior and Destination Service ownership.

## Public Repository Treatment

The original manifests are not included as active implementation files. The final reference implementation uses stable Terraform-managed routes and Destination Service.
