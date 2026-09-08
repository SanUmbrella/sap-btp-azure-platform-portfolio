# Cloud Foundry Provider Reproducer Sketch

This is a placeholder for a future minimal reproducer. It is not a runnable lab yet and does not contain live Cloud Foundry credentials or environment-specific values.

## Goal

Reduce observed Cloud Foundry provider adoption behavior to the smallest possible configuration:

```text
cloudfoundry_app
cloudfoundry_service_instance
cloudfoundry_service_credential_binding
```

## Evidence To Capture

1. `terraform apply` creates the app and binding.
2. A second `terraform plan` with no HCL changes proposes replacement.
3. `terraform show -json` or saved plan JSON shows:

```text
replace_paths = [["app"]]
after_unknown.app = true
```

## Current Status

Planned. Before opening an upstream issue, reproduce against the current Cloud Foundry provider version and compare against the version used when the lab behavior was observed.
